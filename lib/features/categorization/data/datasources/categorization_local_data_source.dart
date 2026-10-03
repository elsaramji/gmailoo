import '../models/sender_override_model.dart';

abstract class CategorizationLocalDataSource {
  Future<SenderOverrideModel?> getOverrideFor(String senderAddress);
  Future<void> saveOverride(SenderOverrideModel override);
  Future<List<SenderOverrideModel>> getAllOverrides();
}
