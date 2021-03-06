import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'package:invoiceninja/data/models/serializers.dart';
import 'package:built_collection/built_collection.dart';

import 'package:invoiceninja/redux/auth/auth_state.dart';
import 'package:invoiceninja/data/models/models.dart';
import 'package:invoiceninja/data/web_client.dart';

class ProductRepository {
  final WebClient webClient;

  const ProductRepository({
    this.webClient = const WebClient(),
  });

  Future<BuiltList<ProductEntity>> loadList(CompanyEntity company, AuthState auth) async {

    final response = await webClient.get(
        auth.url + '/products', company.token);

    ProductListResponse productResponse = serializers.deserializeWith(
        ProductListResponse.serializer, response);

    return productResponse.data;
  }

  Future saveData(CompanyEntity company, AuthState auth, ProductEntity product, [EntityAction action]) async {

    var data = serializers.serializeWith(ProductEntity.serializer, product);
    var response;

    if (product.isNew()) {
      response = await webClient.post(
          auth.url + '/products', company.token, json.encode(data));
    } else {
      var url = auth.url + '/products/' + product.id.toString();
      if (action != null) {
        url += '?action=' + action.toString();
      }
      response = await webClient.put(url, company.token, json.encode(data));
    }

    ProductItemResponse productResponse = serializers.deserializeWith(
        ProductItemResponse.serializer, response);

    return productResponse.data;
  }
}