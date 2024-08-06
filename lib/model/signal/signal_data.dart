
import 'package:json_annotation/json_annotation.dart';

part 'signal_data.g.dart';

@JsonSerializable(explicitToJson: true)
 class Signals {
  String? status;
  String? id;
  String? symbol;
  String? time_frame;
  String? trade_type;
  String? entry_price_one;
  String? entry_price_two;
  String? take_profit_one;
  String? take_profit_two;
  String? stop_loss;
  String? text;
  String? created_at;
  String? updated_at;
  String? image;


  Signals(this.status, this.id, this.symbol, this.time_frame, this.trade_type,
      this.entry_price_one, this.entry_price_two, this.take_profit_one,
      this.take_profit_two, this.stop_loss, this.text, this.created_at,
      this.updated_at, this.image);


  factory Signals.fromJson(final json) =>  _$SignalsFromJson(json);

  Map<String, dynamic> toJson() => _$SignalsToJson(this);
 }

@JsonSerializable(explicitToJson: true)
 class NewSignals {
  String symbol;
  String time_frame;
  String trade_type;
  String entry_price_one;
  String entry_price_two;
  String take_profit_one;
  String take_profit_two;
  String stop_loss;
  String text;
  String created_at;
  String updated_at;
  String image;

  NewSignals( this.symbol, this.time_frame, this.trade_type,
      this.entry_price_one, this.entry_price_two, this.take_profit_one,
      this.take_profit_two, this.stop_loss, this.text, this.created_at,
      this.updated_at, this.image);

  factory NewSignals.fromJson(final json) =>  _$NewSignalsFromJson(json);

  Map<String, dynamic> toJson() => _$NewSignalsToJson(this);

 }




// flutter packages pub run build_runner build