import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class Interaction implements InteractionContract {
  final String _token;
  final Snowflake _id;
  final Snowflake _botId = ioc.resolve<Bot>().id;

  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  Interaction(this._token, this._id);

  @override
  Future<InteractionContract> reply({
    required MessageBuilder builder,
    bool ephemeral = false,
  }) async {
    await _datastore.interaction.replyInteraction(
      _id,
      _token,
      builder,
      ephemeral,
    );
    return this;
  }

  @override
  Future<InteractionContract> editReply({
    required MessageBuilder builder,
    bool ephemeral = false,
  }) async {
    await _datastore.interaction.editInteraction(
      _botId,
      _token,
      builder,
      ephemeral,
    );
    return this;
  }

  @override
  Future<void> deleteReply() async {
    await _datastore.interaction.deleteInteraction(_botId, _token);
  }

  @override
  Future<void> noReply({bool ephemeral = false}) async {
    await _datastore.interaction.noReplyInteraction(_id, _token, ephemeral);
  }

  @override
  Future<InteractionContract> followup({
    required MessageBuilder builder,
    bool ephemeral = false,
  }) async {
    await _datastore.interaction.createFollowup(
      _botId,
      _token,
      builder,
      ephemeral,
    );
    return this;
  }

  @override
  Future<InteractionContract> editFollowup({
    required MessageBuilder builder,
    bool ephemeral = false,
  }) async {
    await _datastore.interaction.editFollowup(
      _botId,
      _token,
      _id,
      builder,
      ephemeral,
    );
    return this;
  }

  @override
  Future<void> deleteFollowup() async {
    await _datastore.interaction.deleteFollowup(_botId, _token, _id);
  }

  @override
  Future<InteractionContract> wait() async {
    await _datastore.interaction.waitInteraction(_id, _token);
    return this;
  }

  @override
  Future<void> modal(ModalBuilder modal) async {
    await _datastore.interaction.sendModal(_id, _token, modal);
  }
}
