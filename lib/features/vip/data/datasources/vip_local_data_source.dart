import '../models/vip_sender_model.dart';

abstract class VipLocalDataSource {
  Future<List<VipSenderModel>> getVipSenders();
  Future<void> insertVipSender(VipSenderModel sender);
  Future<void> deleteVipSender(String email);
  Future<void> updateMuteStatus(String email, bool isMuted);
}
