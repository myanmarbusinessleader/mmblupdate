import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterSearchList extends StatelessWidget {
  const FilterSearchList({
    super.key,
    required this.query,
    required this.onSelected,
  });

  final void Function(String value) onSelected;
  final Query<Object?> query;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirestorePagination(
        initialLoader: const CupertinoActivityIndicator(),
        bottomLoader: const CupertinoActivityIndicator(),
        limit: 10,
        query: query,
        itemBuilder: (context, docs, index) {
          final data = docs[index].data() as Map<String, dynamic>;
          return InkWell(
            onTap: () => onSelected(data["name"]),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data["name"],
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
