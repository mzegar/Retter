// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postpage_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostPageViewModel on PostPageViewModelBase, Store {
  final _$commentsAtom = Atom(name: 'PostPageViewModelBase.comments');

  @override
  List<Comment> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(List<Comment> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  @override
  String toString() {
    return '''
comments: ${comments}
    ''';
  }
}
