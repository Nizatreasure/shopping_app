# **Project Overview**

A mobile app that allows users to browse and shop for various products from different brands. It includes features like product filtering, cart management, and order placement.

## **Setup Instructions** :gear:

1. **Clone the repository from github**

   ```sh
   git clone https://github.com/Nizatreasure/shopping_app.git
   ```

2. **Navigate to the project folder**

   ```sh
   cd shopping_app
   ```

3. **Install dependencies**
   ```sh
   flutter pub get
   ```
<br>

**Android**

Everything is set. Whatever is needed would be automatically downloaded when you run the project.

Run the project using

```sh
flutter run
```
<br>

**iOS**

Navigate into the ios folder by running
```sh
cd ios
```
To install dependencies and update your local pod file run
```sh
pod install --repo-update
```
Navigate back to the project directory by running
```sh
cd ..
```

Run the project using 
```sh
flutter run
```

**NOTE:** An active device (emulator or real) must be connected. A stable internet connection is required. A MacBook is necessary to run the project on iOS.

<br>

### **Assumptions Made** :memo:


- Infinite scroll is only for the **discover** page. The infinite scroll was however **not** implemented when **filter** is **active**. i.e You can scroll infinitely on the discover page, on any tab but once a filter is selected, infinite scroll is disabled until the filter is reset.

- Filters is only for the **All** tab in discover page. The button becomes invisible on other tabs. This is because the other tabs are already filtered according to brands.

- Brands are **dynamic**, hence a firestore collection was created to store product brands and the brands are being fetched into the application.

- Location and payment method in the order summary page were assumed to be **static**, hence, a constant value is used within the application.

- After successfully checking out an order, it is assumed that the cart is to be cleared.

- Limited the **maximum** quantity of an item that can be selected when adding to cart to **ten** (10).

- The application closely follows the provided **Figma** design for UI/UX **consistency**.

- No authentication, hence, every user of the app shares the **same** instance. i.e whatever changes is made on one device automatically reflects on all other devices using the application.

- Only **one** can be selected at a time from each of the filter sections.

- There must always be a minimum difference of 50 between the **minimum** and **maximum** price range in the filter page. **NOTE** that the **minimum** and **maximum** values of the price range were not place at the bottom of the slider like it was in the UI. This is because there would be an overlap of those values and the current values of the slider when ever the slider is moved towards the edge. With this in mind, I moved the **minimum** and **maximum** values to the top of the slider.

<br>

### **Challenges Faced** :wrench:

Some challenges faced include:
- _**Animating removal of items from cart**_: I used **AnimatedList** and some other widgets to achieve this. I however had some issues while updating the quantity of a particular product. Even without adding or removing from the cart list [_I was only updating the quantity of a product, not the size of the list_], I was getting an **out-of-range** error. I solved this by providing a **global key**.

- _**Creating the shimmer effect**_: I decided to use a **shimmer effect** instead of a normal loading indicator. It took some time to implement across the application and I also had to create a custom class **ShimmerWidget** class for it.

- _**Database structure**_: This was not much of a challenge, but some thought process was put into deciding what structure would fit the app's requirements. All it took was a pen and a paper to draft out the structure.

- _**Cloud functions**_: I had some issues deploying the cloud functions after writing them and testing using firebase emulator. The error was kind of vague, but after some research, I discovered it had to do with improper **permissions**. I had to install **gcloud** on my terminal and configure a default login.


### **Additional Features** :sparkles:

Some additional features include:
- The loading screens for the applicaton makes use of the **Shimmer** effect. I figured this would be more appropriate for a shopping app.

- _**Custom page transition**_ - I added a custom page transition. Pages in the application open from **bottom-to-top** and when closing, they close from **top-to-bottom**.

- All **filters** in the filter page are **active**. (_not just the brand and price range filter as suggested by the document_)

- **Animated** the modal that shows up when you add an item to **cart** successfully. I also added a **success modal** when you click on _"payment button"_ in the order summary page. A **loader** was added to show the processing state.

- **Limited** the maximum selectable quantity when adding a product to cart to **10**. That is, a user cannot add a quantity greater than 10 for a single product.

- When you add a product to cart and you open the detail view of that same product, your **selections** for the cart **reflects** on the page. When you click the _"ADD TO CART"_ button, a new product is **not** added to the cart, rather, the existing product in the cart is **updated** to reflect your current **selection**. _(assuming you made any changes, if not is stays the same)_

- **Added** an animation that shows as items are **deleted** and removed from the cart which provides a good user experience.

- **Confirmation** before removing a product form cart.

- The **delete button** can be made visible by **sliding** or **long-pressing** on a cart item. It can also be closed by tapping on it. An open delete button is automatically closed when the delete button for another item is opened.

- **Added** a background **blur** when the app enters the **processing** state. (_when adding to cart or processing a payment_)

- **Clicking** on a cart item **opens** the product view page.

- When you select a filter in a **Row** on the filter page, it automatically **scrolls** into view. It also **scrolls** to the selected filter in the **Row** when you open the filter page. _(if the selected filter is out of the viewport of your device screen)_

- Wrote a **cloud** function to calculate the **total** number of **products** for each **brand** and update the database with the value.

- **Unit** test for **blocs** and **firestore** services.

- Used **Streams** for the cart, to ensure the cart is always **up-to-date** with the database.

- Double press back button to close app. This helps prevent unintentional exit.
