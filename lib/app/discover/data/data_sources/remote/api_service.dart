import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/filter_model.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';
import 'package:shopping_app/app/discover/data/models/product_review_model.dart';
import 'package:shopping_app/core/common/extenstions/gender_extension.dart';
import 'package:shopping_app/core/common/extenstions/sort_by_extension.dart';

class DiscoverApiService {
  final FirebaseFirestore _firestore;
  const DiscoverApiService(this._firestore);

  CollectionReference get _brandReference => _firestore.collection('brands');
  CollectionReference get _reviewReference => _firestore.collection('reviews');
  CollectionReference get _productReference =>
      _firestore.collection('products');

  //I'm not limiting the number of brands gotten
  //because the brands are not many, but majorly it is
  //because the brand names are used as tabs in the app
  Future<QuerySnapshot<BrandsModel>> getAllBrands() {
    return _brandReference
        .withConverter<BrandsModel>(
            fromFirestore: (snapshot, _) =>
                BrandsModel.fromJson(snapshot.data()!),
            toFirestore: (brands, _) => brands.toJson())
        .get();
  }

  //default order in the app is to sort by highest price
  //no limit was set (no pagination) because the products in the
  //database is very small
  Future<QuerySnapshot<ProductModel>> getProductList(String brandName) async {
    Query query = _productReference;
    if (brandName.isNotEmpty) {
      query = query.where('brand', isEqualTo: brandName);
    }
    return query
        .withConverter<ProductModel>(
            fromFirestore: (snapshot, _) => ProductModel.fromSnapshot(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }

  //get product details for a single product with the
  //document id
  Future<DocumentSnapshot<ProductModel>> getProductDetails(String docID) {
    return _productReference
        .doc(docID)
        .withConverter<ProductModel>(
            fromFirestore: (snapshot, _) => ProductModel.fromSnapshot(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }

  //get a list of products according to the selected filters
  //and sortby options
  Future<QuerySnapshot<ProductModel>> getFilteredProductList(
      FilterModel filter) async {
    Query query = _productReference;

    if (filter.priceRange != null) {
      query = query
          .where('price.amount',
              isGreaterThanOrEqualTo: filter.priceRange!.minPrice)
          .where('price.amount',
              isLessThanOrEqualTo: filter.priceRange!.maxPrice);
    }

    if (filter.color != null) {
      query = query.where('colors', arrayContains: filter.color!.toJson());
    }

    if (filter.brand != null) {
      query = query.where('brand', isEqualTo: filter.brand!.name);
    }

    if (filter.gender != null) {
      query = query.where('gender', isEqualTo: filter.gender!.displayName);
    }

    if (filter.sortBy != null) {
      query = query.orderBy(filter.sortBy!.sortBy.sortingField,
          descending: filter.sortBy!.descending);
    }

    return query
        .withConverter<ProductModel>(
            fromFirestore: (snapshot, _) => ProductModel.fromSnapshot(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }

  // Get the total product reviews. If a rating is passed,
  //it gets all the revies with that rating
  //
  //Sorting the query by created time and descending to have newest reviews
  //at the top
  Future<QuerySnapshot<ProductReviewModel>> getProductReviews(
      int productID, int? rating) async {
    Query query = _reviewReference.where('product_id', isEqualTo: productID);
    if (rating != null) {
      query = query.where('rating', isEqualTo: rating);
    }
    return query
        .orderBy('created_at', descending: true)
        .withConverter<ProductReviewModel>(
            fromFirestore: (snapshot, _) =>
                ProductReviewModel.fromSnapshot(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }

  //Gets the top three rated comments for a particular product
  Future<QuerySnapshot<ProductReviewModel>> getTopThreeReviews(int productID) {
    return _reviewReference
        .where('product_id', isEqualTo: productID)
        .orderBy('rating', descending: true)
        .limit(3)
        .withConverter<ProductReviewModel>(
            fromFirestore: (snapshot, _) =>
                ProductReviewModel.fromSnapshot(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }
}
