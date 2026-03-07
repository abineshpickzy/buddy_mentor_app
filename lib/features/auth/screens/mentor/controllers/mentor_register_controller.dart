import 'package:buddymentor/features/auth/screens/mentee/models/country_model.dart';
import 'package:buddymentor/features/auth/screens/mentee/models/discipline_model.dart';
import 'package:buddymentor/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MentorRegisterData {
  final List<Discipline> disciplines;
  final List<Country> countries;

  MentorRegisterData({
    required this.disciplines,
    required this.countries,
  });
}

class MentorRegisterController extends AsyncNotifier<MentorRegisterData> {
  @override
  Future<MentorRegisterData> build() async {
    final disciplines = await fetchDisciplines();
    final countries = await fetchCountries();
    return MentorRegisterData(disciplines: disciplines, countries: countries);
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

final mentorRegisterControllerProvider = AsyncNotifierProvider<MentorRegisterController, MentorRegisterData>(
  MentorRegisterController.new,
);