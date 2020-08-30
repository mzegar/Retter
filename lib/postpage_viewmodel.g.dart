// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postpage_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PageComment on PageCommentModelBase, Store {
  final _$isCollapsedAtom = Atom(name: 'PageCommentModelBase.isCollapsed');

  @override
  bool get isCollapsed {
    _$isCollapsedAtom.reportRead();
    return super.isCollapsed;
  }

  @override
  set isCollapsed(bool value) {
    _$isCollapsedAtom.reportWrite(value, super.isCollapsed, () {
      super.isCollapsed = value;
    });
  }

  final _$isBelowCollapsedAtom =
      Atom(name: 'PageCommentModelBase.isBelowCollapsed');

  @override
  bool get isBelowCollapsed {
    _$isBelowCollapsedAtom.reportRead();
    return super.isBelowCollapsed;
  }

  @override
  set isBelowCollapsed(bool value) {
    _$isBelowCollapsedAtom.reportWrite(value, super.isBelowCollapsed, () {
      super.isBelowCollapsed = value;
    });
  }

  @override
  String toString() {
    return '''
isCollapsed: ${isCollapsed},
isBelowCollapsed: ${isBelowCollapsed}
    ''';
  }
}

mixin _$PostPageViewModel on PostPageViewModelBase, Store {
  final _$loadingCommentsAtom =
      Atom(name: 'PostPageViewModelBase.loadingComments');

  @override
  bool get loadingComments {
    _$loadingCommentsAtom.reportRead();
    return super.loadingComments;
  }

  @override
  set loadingComments(bool value) {
    _$loadingCommentsAtom.reportWrite(value, super.loadingComments, () {
      super.loadingComments = value;
    });
  }

  final _$commentsAtom = Atom(name: 'PostPageViewModelBase.comments');

  @override
  List<PageComment> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(List<PageComment> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  @override
  String toString() {
    return '''
loadingComments: ${loadingComments},
comments: ${comments}
    ''';
  }
}
