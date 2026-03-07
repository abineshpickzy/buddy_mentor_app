import 'package:buddymentor/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/discipline_model.dart';
import '../models/country_model.dart';

class MenteeRegisterData {
  final List<Discipline> disciplines;
  final List<Country> countries;

  MenteeRegisterData({
    required this.disciplines,
    required this.countries,
  });
}

class MenteeRegisterController extends AsyncNotifier<MenteeRegisterData> {
  @override
  Future<MenteeRegisterData> build() async {
    final disciplines = await fetchDisciplines();
    final countries = await fetchCountries();
    return MenteeRegisterData(disciplines: disciplines, countries: countries);
  }

  Future<List<Discipline>> fetchDisciplines() async {
    try {
      final response = await AuthService.getDisciplineList();
      if (response.statusCode == 200 && response.data['success'] == true) {
        final disciplineResponse = DisciplineResponse.fromJson(response.data);
        return disciplineResponse.disciplines;
      }
      return [];
    } catch (error) {
      throw error;
    }
  }

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await AuthService.getCountryList();
      if (response.statusCode == 200 && response.data['success'] == true) {
        final countryResponse = CountryResponse.fromJson(response.data);
        return countryResponse.countries;
      }
      return [];
    } catch (error) {
      throw error;
    }
  }
}

final menteeRegisterControllerProvider = AsyncNotifierProvider<MenteeRegisterController, MenteeRegisterData>(
  MenteeRegisterController.new,
);