// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signal_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Signals _$SignalsFromJson(Map<String, dynamic> json) {
  return Signals(
    json['status'] as String,
    json['id'] as String,
    json['symbol'] as String,
    json['time_frame'] as String,
    json['trade_type'] as String,
    json['entry_price_one'] as String,
    json['entry_price_two'] as String,
    json['take_profit_one'] as String,
    json['take_profit_two'] as String,
    json['stop_loss'] as String,
    json['text'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['image'] as String,
  );
}

Map<String, dynamic> _$SignalsToJson(Signals instance) => <String, dynamic>{
      'status': instance.status,
      'id': instance.id,
      'symbol': instance.symbol,
      'time_frame': instance.time_frame,
      'trade_type': instance.trade_type,
      'entry_price_one': instance.entry_price_one,
      'entry_price_two': instance.entry_price_two,
      'take_profit_one': instance.take_profit_one,
      'take_profit_two': instance.take_profit_two,
      'stop_loss': instance.stop_loss,
      'text': instance.text,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'image': instance.image,
    };

NewSignals _$NewSignalsFromJson(Map<String, dynamic> json) {
  return NewSignals(
    json['symbol'] as String,
    json['time_frame'] as String,
    json['trade_type'] as String,
    json['entry_price_one'] as String,
    json['entry_price_two'] as String,
    json['take_profit_one'] as String,
    json['take_profit_two'] as String,
    json['stop_loss'] as String,
    json['text'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['image'] as String,
  );
}

Map<String, dynamic> _$NewSignalsToJson(NewSignals instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'time_frame': instance.time_frame,
      'trade_type': instance.trade_type,
      'entry_price_one': instance.entry_price_one,
      'entry_price_two': instance.entry_price_two,
      'take_profit_one': instance.take_profit_one,
      'take_profit_two': instance.take_profit_two,
      'stop_loss': instance.stop_loss,
      'text': instance.text,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'image': instance.image,
    };
