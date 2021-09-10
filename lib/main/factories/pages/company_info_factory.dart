import 'package:flutter/widgets.dart';

import '../../../presentation/ui/ui.dart';

import '../presenters/presenters.dart';

Widget makeCompanyInfoPage() {
  return CompanyInfoPage(makeGetxCompanyInfoPresenter());
}
