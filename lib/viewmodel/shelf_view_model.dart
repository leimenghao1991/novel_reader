import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novel_reader/model/shelf_view_beans.dart';
import 'package:novel_reader/repo/bean/service_bean.dart';
import 'package:novel_reader/repo/shelf_repo.dart';

class ShelfViewModel {
  BookRepo _repo;

  ShelfViewModel() {
    _repo = new BookRepo();
  }

  Stream<List<ShelfBook>> shelfBookSteam() {
    return _repo
        .getShelfBooks("male")
        .asStream();
  }
}
