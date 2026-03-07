import 'package:buddymentor/features/auth/data/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/discipline_model.dart';
import '../models/country_model.dart';
import '../models/program_model.dart';

class MenteeRegisterData {
  final List<Discipline> disciplines;
  final List<Country> countries;
  final List<Program> programs;

  MenteeRegisterData({
    required this.disciplines,
    required this.countries,
    required this.programs,
  });
}

class MenteeRegisterController extends AsyncNotifier<MenteeRegisterData> {
  @override
  Future<MenteeRegisterData> build() async {
    final disciplines = await fetchDisciplines();
    final countries = await fetchCountries();
    final programs = await fetchPrograms();
    return MenteeRegisterData(disciplines: disciplines, countries: countries, programs: programs);
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

final menteeRegisterControllerProvider = AsyncNotifierProvider<MenteeRegisterController, MenteeRegisterData>(
  MenteeRegisterController.new,
);