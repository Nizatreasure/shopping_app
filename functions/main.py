
from firebase_functions import firestore_fn
from firebase_admin import firestore, initialize_app, credentials
from google.cloud.firestore_v1.base_query import FieldFilter

cred = credentials.ApplicationDefault()
app = initialize_app(cred)
db = firestore.client()


#Triggering the function to calculate rating for the product each time an existing review is updated
#or deleted or a new review is created

@firestore_fn.on_document_written(document="reviews/{review_id}")
def calculate_product_rating(event: firestore_fn.Event[firestore_fn.Change[firestore_fn.DocumentSnapshot | None]]) -> None:


    #initialized to zero 
    before_rating = 0
    after_rating = 0

    #keeps track of events (if it is an update, deletion or creation)
    review_count = 0

    

    if event.data.before is not None:
        before_rating = event.data.before.get('rating')
        try:
            product_id = event.data.before.get('product_id')
            review_count -= 1
        except KeyError:
            return


    if event.data.after is not None:
        after_rating = event.data.after.get('rating')
        try:
            product_id = event.data.after.get('product_id')
            review_count += 1
        except KeyError:
            return


    #Get the product with the product id
    product_list = db.collection('products').where(filter=FieldFilter('id','==',product_id)).get()

    if(len(product_list)>0):
        product = product_list[0]
        try: 
            product_data = product.to_dict()
            review_info = product_data.get('review_info', {})
            total_rating = review_info.get('total_rating', 0)
            total_reviews = review_info.get('total_reviews',0)
            
        except KeyError: 
            total_rating = 0
            total_reviews = 0
        
        total_rating = total_rating + after_rating - before_rating
        total_reviews = total_reviews + review_count

        if total_reviews == 0:
            average_rating = 0
        else:
            average_rating = round(total_rating / total_reviews,1)

        db.collection('products').document(product.id).update({'review_info': {"average_rating": average_rating, "total_reviews": total_reviews, 'total_rating': total_rating}})





