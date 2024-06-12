
from firebase_functions import firestore_fn
from firebase_admin import firestore, initialize_app, credentials
from google.cloud.firestore_v1.base_query import FieldFilter

cred = credentials.ApplicationDefault()
app = initialize_app(cred)
db = firestore.client()


#calculate the total products for a given brand
@firestore_fn.on_document_written(document="products/{product_id}")
def calculate_total_product_for_brand(event: firestore_fn.Event[firestore_fn.Change[firestore_fn.DocumentSnapshot | None]]) -> None:
    
    brand_name_before = None
    brand_name_after = None

    if event.data.before is not None: 
        try:
            brand_name_before = event.data.before.get('brand')
        except KeyError:
            return

    if event.data.after is not None:
        try:
            brand_name_after = event.data.after.get('brand')
        except KeyError:
            return
        
    #do nothing if the brand was not changed i.e if brand_name_before == brand_name_after

    
    #brand was deleted, so reduce the brand count
    if brand_name_before is not None and brand_name_before != brand_name_after:
        update_brand_product_count(brand_name_before, -1)

    #brand was added, so increase the brand count
    if brand_name_after is not None and brand_name_after != brand_name_before:
        update_brand_product_count(brand_name_after, 1)
    
    
# Function to update the number of products for a given brand
def update_brand_product_count(brand_name, count):
    brand_list = db.collection('brands').where(filter=FieldFilter('name','==',brand_name)).get()
    if(len(brand_list)>0):
        brand_data = brand_list[0].to_dict()
        previous_total_brand_product = brand_data.get('total_product_count', 0)
        total_brand_product = max(0, previous_total_brand_product+count)
        db.collection('brands').document(brand_list[0].id).update({'total_product_count': total_brand_product})




#Triggering the function to calculate rating for the product each time an existing review is updated
#or deleted or a new review is created

@firestore_fn.on_document_written(document="reviews/{review_id}")
def calculate_product_rating(event: firestore_fn.Event[firestore_fn.Change[firestore_fn.DocumentSnapshot | None]]) -> None:


    #initialized to zero 
    before_rating = 0
    after_rating = 0

    #keeps track of events (if it is an update, deletion or creation)
    review_count = 0

    
    # Get the rating before the document was updated or deleted. 

    # If the document was just created, this block would be skipped and the 
    # before rating would be zero
    if event.data.before is not None:
        try:
            before_rating = event.data.before.get('rating')
            product_id = event.data.before.get('product_id')
            review_count -= 1
        except KeyError:
            return

    # Get the rating after the document was created or updated.

    # If the document was deleted, this block would be skipped and the
    # after raing would be zero
    if event.data.after is not None:
        try:
            after_rating = event.data.after.get('rating')
            product_id = event.data.after.get('product_id')
            review_count += 1
        except KeyError:
            return


    #Get the product with the product id
    product_list = db.collection('products').where(filter=FieldFilter('id','==',product_id)).get()

    # Check that there is actually data in the product_list
    if(len(product_list)>0):

        # Get the data from product_list
        product = product_list[0]
        try: 
            product_data = product.to_dict()
            review_info = product_data.get('review_info', {})
            total_rating = review_info.get('total_rating', 0)
            total_reviews = review_info.get('total_reviews',0)
            
        except KeyError: 
            total_rating = 0
            total_reviews = 0
        

        # Calculate the total reviews
        total_rating = total_rating + after_rating - before_rating
        total_reviews = total_reviews + review_count
        
        # This check is necessary because dividing by zero would throw an error 
        if total_reviews == 0:
            average_rating = 0
        else:
            #round the average rating to 1 decimal place
            average_rating = round(total_rating / total_reviews,1)

        # Update the database with the new average
        db.collection('products').document(product.id).update({'review_info': {"average_rating": average_rating, "total_reviews": total_reviews, 'total_rating': total_rating}})





