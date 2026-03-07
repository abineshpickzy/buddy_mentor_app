import 'package:buddymentor/features/auth/screens/mentee/models/country_model.dart';
import 'package:buddymentor/features/auth/screens/mentee/models/discipline_model.dart';
import 'package:buddymentor/features/auth/screens/mentee/models/program_model.dart';
import 'package:buddymentor/features/auth/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MentorRegisterData {
  final List<Discipline> disciplines;
  final List<Country> countries;
  final List<Program> programs;

  MentorRegisterData({
    required this.disciplines,
    required this.countries,
    required this.programs,
  });
}

class MentorRegisterController extends AsyncNotifier<MentorRegisterData> {
  @override
  Future<MentorRegisterData> build() async {
    final disciplines = await fetchDisciplines();
    final countries = await fetchCountries();
    final programs = await fetchPrograms();
    return MentorRegisterData(disciplines: disciplines, countries: countries, programs: programs);
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

  Future<List<Program>> fetchPrograms() async {
    try {
      final response = await AuthService.getProgramList();
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> programData = response.data['data'];
        return programData.map((json) => Program.fromJson(json)).toList();
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