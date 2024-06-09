import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/app/discover/data/models/brands_model.dart';
import 'package:shopping_app/app/discover/data/models/product_model.dart';

class DiscoverApiService {
  final FirebaseFirestore _firestore;
  const DiscoverApiService(this._firestore);

  CollectionReference get _brandReference => _firestore.collection('brands');
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
  //the limit was set to 20 products for each request
  Future<QuerySnapshot<ProductModel>> getProductList(String name) async {
    return _productReference
        .orderBy('price.amount', descending: true)
        .startAfter([name])
        .limit(20)
        .withConverter<ProductModel>(
            fromFirestore: (snapshot, _) => ProductModel.fromJson(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }

  // createProduct(Map<String, dynamic> data) async {
  //   DocumentReference docID = await _productReference.add(data);
  //   print(docID.id);
  // }

  //get product details for a single product with the
  //document id
  Future<DocumentSnapshot<ProductModel>> getProductDetails(String docID) {
    return _productReference
        .doc(docID)
        .withConverter<ProductModel>(
            fromFirestore: (snapshot, _) => ProductModel.fromJson(snapshot),
            toFirestore: (model, _) => model.toJson())
        .get();
  }
}
