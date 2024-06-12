# Project Overview

A mobile app that allows users to browse and shop for various products from different brands. It includes features like product filtering, cart management, and order placement.



## Setup Instructions :gear:
   
1. **Clone the repository from github** 
   ```sh
   "git clone https://github.com/Nizatreasure/shopping_app.git"
   ```

2. **Navigate to the project folder**
    ```sh
    "cd shopping_app"
    ```

3. **Install dependencies**
     ```sh
    "flutter pub get"
    ```

    
**Android**

    Everything is set. Whatever is needed would be automatically downloaded when you run the project.
**Run the project**
    ```sh
    "flutter run"
    ```
    

**iOS**

Navigate into the ios folder by running "cd ios" from the project directory
Run "pod install --repo-update" to install dependencies and update your local pod file
Navigate back to the project directory by running "cd .."
Run the project using "flutter run"

NOTE: An active device (emulator or real) must be connected. A stable internet connection is required. A MacBook is necessary to run the project on iOS.


### Assumptions Made :memo:
    
- Infinite scroll is only for the [discover] page. The infinite scroll was however [not] implemented when [filter] is [active]. i.e You can scroll infinitely on the discover page, on any tab but once a filter is selected, infinite scroll is disabled until the filter is reset.

- Filters is only for the [All] tab in discover page. The button becomes invisible on other tabs. This is because the other tabs are already filtered according to brands.

- Brands are [dynamic], hence a firestore collection was created to store product brands and the brands are being fetched into the application.

- Location and payment method in the order summary page were assumed to be [static], hence, a constant value is used within the application.

- After successfully checking out an order, it is assumed that the cart is to be cleared. 

- Limited the [maximum] quantity of an item that can be selected when adding to cart to [ten] (10).

- The application closely follows the provided [Figma] design for UI/UX [consistency].

- No authentication, hence, every user of the app shares the [same] instance. i.e whatever changes is made on one device automatically reflects on all other devices using the application.

- Only [one] can be selected at a time from each of the filter sections.

- There must always be a minimum difference of 50 between the [minimum] and [maximum] price range in the filter page. [NOTE] that the [minimum] and [maximum] values of the price range were not place at the bottom of the slider like it was in the UI. This is because there would be an overlap of those values and the current values of the slider when ever the slider is moved towards the edge. With this in mind, I moved the [minimum] and [maximum] values to the top of the slider. 





#### Challenges Faced :wrench:

Some challenges faced include:

- *Animating removal of items from cart:* I used [AnimatedList] and some other widgets to achieve this. I however had some issues while updating the quantity of a particular product. Even without adding or removing from the list (cart list)[I was only updating the quantity of a product, not the size of the list], I was getting an [out-of-range] error. I solved this by providing a global key.

- *Creating the shimmer effect:*  I decided to use a shimmer effect instead of a normal loading indicator. It took some time to implement across the application and I also had to create a custom class [ShimmerWidget] for it.

- *Database structure:* This is not much of a challenge, but some thought process was put into deciding which structure would fit the app's requirements. All it took was a pen and a paper to draft out the structure.

- *Cloud functions:* I had some issues deploying the cloud functions after writing them and testing using firebase emulator. The error was kind of vague, but after some research, I discovered it had to do with improper [permissions]. I had to install gcloud on my terminal and configure a default login.

    

##### Additional Features :sparkles:

Some additional features include:

- The loading screens for the applicaton makes use of the [Shimmer] effect. I figured this would be more appropriate for a shopping app.

- *Custom page transition* - I added a custom page transition. Pages in the application open from [bottom-to-top] and when closing, they close from [top-to-bottom].

- All [filters] in the filter page are [active] [not just the brand and price range filter as suggested by the document].

- [Animated] the modal that shows up when you add an item to [cart] successfully. I also added a [success] modal when you click on payment button in the order summary page. A [loader] was added to show the processing state.

- [Limited] the maximum selected quantity when adding a product to cart to [10]. That is, a user cannot add a quantity greater than 10 for a single product.

- When you add a product to cart and you open the detail view of that same product, your [selections] for the cart [reflects] on the page. When you click the [ADD TO CART] button, a new product is [not] added to the cart, rather, the existing product in the cart is [updated] to reflect your current [selection] (assuming you made any changes, if not is stays the same).

- [Added] an animation that shows as items are [deleted] from the cart which provides a good user experience. 

- [Confirmation] before removing a product form cart.

- The delete button can be made visible by [sliding] or [long-pressing] on a cart item. It can also be closed by tapping on it. An open delete button is automatically closed when the delete button for another item is opened.

- [Added] a background [blur] when the app enters the [processing] state [When adding to cart or processing a payment].

- Clicking on a cart item [opens] the product view page.

- When you select a filter in a [Row] on the filter page, it automatically [scrolls] into view. It also [scrolls] to the selected filter in the [Row] when you open the filter page (if the selected filter is out of the viewport of your device screen).

- Wrote a [cloud] function to calculate the [total] number of [products] for each [brand] and update the database with the value.

- Added [loaders] and material [banners] to communication different states and information to users.

- Added [error] pages for when an error occurs in the app. Also added a [no-product], [no-review], [no-item-in-cart] page for when any of the respective collections in the database are empty, or when an active filter doesn't return any match.

- [Unit] test for [blocs] and [firestore] services.

- Used Streams for the cart, [DocumentSnapshot] to ensure the cart is always [up-to-date] with the database.

