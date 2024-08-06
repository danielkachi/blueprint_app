// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentPlan _$PaymentPlanFromJson(Map<String, dynamic> json) {
  return PaymentPlan(
    (json['plans'] as List)
        .map((e) => e == null ? null : PlanData.fromJson(e))
        .toList(),
  );
}

Map<String, dynamic> _$PaymentPlanToJson(PaymentPlan instance) =>
    <String, dynamic>{
      'plans': instance.plans.map((e) => e!.toJson()).toList(),
    };

PlanData _$PlanDataFromJson(Map<String, dynamic> json) {
  return PlanData(
    json['id'] as int,
    json['name'] as String,
    json['duration'] as String,
    json['amount'] as String,
    json['discount'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
  );
}

Map<String, dynamic> _$PlanDataToJson(PlanData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'duration': instance.duration,
      'amount': instance.amount,
      'discount': instance.discount,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };
