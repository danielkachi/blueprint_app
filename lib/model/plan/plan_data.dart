
import 'package:json_annotation/json_annotation.dart';

part 'plan_data.g.dart';

@JsonSerializable(explicitToJson: true)
class PaymentPlan{
  List<PlanData?> plans;

  PaymentPlan(this.plans);

  factory PaymentPlan.fromJson(final json) =>  _$PaymentPlanFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentPlanToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlanData {
  int id;
  String name;
  String duration;
  String amount;
  String discount;
  String created_at;
  String updated_at;

  PlanData(this.id, this.name, this.duration, this.amount, this.discount,
      this.created_at, this.updated_at);

  factory PlanData.fromJson(final json) =>  _$PlanDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlanDataToJson(this);

}


