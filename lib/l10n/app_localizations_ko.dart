// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pack Up!';

  @override
  String get start => '시작하기';

  @override
  String get startScreenAppInfo => '여행 준비부터 시험 준비까지\n모든 준비를 한 곳에서';

  @override
  String get menuTitlesTravel => '여행 준비';

  @override
  String get menuTitlesStudy => '시험 준비';

  @override
  String get menuTitlesShopping => '쇼핑 목록';

  @override
  String get menuTitlesMove => '이사 체크';

  @override
  String get menuTitlesFitness => '운동 루틴';

  @override
  String get menuTitlesDaily => '하루 계획';

  @override
  String get menuTitlesWork => '업무 준비';

  @override
  String get menuTitlesEtc => '기타 목록';

  @override
  String get emptyItemText => '아직 항목이 없어요 🙂\n+ 버튼으로 추가해보세요';

  @override
  String get suggestionBtnText => '추천해드릴까요? 이곳을 클릭하세요!';

  @override
  String get suggestions => '추천 항목';

  @override
  String get addItem => '항목 추가';

  @override
  String get addItemHintText => '새 항목을 입력하세요';

  @override
  String get add => '추가';

  @override
  String get cancel => '취소';

  @override
  String get deleteItem => '항목 삭제';

  @override
  String get deleteAlertText => '정말로 삭제하시겠습니까?\n 이 아래 항목도 삭제됩니다!';

  @override
  String get confirmDelete => '네, 삭제합니다';

  @override
  String get editItem => '항목 수정';

  @override
  String get save => '저장';
}
