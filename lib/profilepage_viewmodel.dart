import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'profilepage_viewmodel.g.dart';

class ProfilePageViewModel = ProfilePageViewModelBase
    with _$ProfilePageViewModel;

abstract class ProfilePageViewModelBase with Store {}
