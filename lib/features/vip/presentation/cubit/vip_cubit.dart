import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/vip_sender.dart';
import '../../domain/usecases/add_vip_sender.dart';
import '../../domain/usecases/get_vip_senders.dart';
import '../../domain/usecases/remove_vip_sender.dart';
import '../../domain/usecases/toggle_vip_mute.dart';
import 'vip_state.dart';

class VipCubit extends Cubit<VipState> {
  final GetVipSenders getVipsUseCase;
  final AddVipSender addVipUseCase;
  final RemoveVipSender removeVipUseCase;
  final ToggleVipMute toggleMuteUseCase;

  VipCubit({
    required this.getVipsUseCase,
    required this.addVipUseCase,
    required this.removeVipUseCase,
    required this.toggleMuteUseCase,
  }) : super(VipInitial());

  Future<void> loadVips() async {
    emit(VipLoading());
    final result = await getVipsUseCase(const NoParams());
    result.fold(
      (f) => emit(VipError(f.message)),
      (senders) => emit(VipLoaded(senders)),
    );
  }

  Future<void> addVip(VipSender sender) async {
    final result = await addVipUseCase(sender);
    result.fold(
      (f) => emit(VipError(f.message)),
      (_) => loadVips(),
    );
  }

  Future<void> removeVip(String email) async {
    final result = await removeVipUseCase(email);
    result.fold(
      (f) => emit(VipError(f.message)),
      (_) => loadVips(),
    );
  }

  Future<void> toggleMute(String email, bool isMuted) async {
    await toggleMuteUseCase(ToggleVipMuteParams(email: email, isMuted: isMuted));
    loadVips();
  }
}
