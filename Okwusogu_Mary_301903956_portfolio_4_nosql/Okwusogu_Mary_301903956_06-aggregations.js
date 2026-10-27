const b=db.getSiblingDB('blitzfintech_nosql');
printjson(b.kyc_profiles.aggregate([{$group:{_id:{status:'$status',riskRating:'$riskRating'},profiles:{$sum:1}}},{$sort:{'_id.status':1,'_id.riskRating':1}}]).toArray());
printjson(b.kyc_profiles.aggregate([{$unwind:'$documents'},{$group:{_id:'$documents.documentType',count:{$sum:1}}},{$sort:{count:-1}}]).toArray());
printjson(b.kyc_profiles.aggregate([{$unwind:'$documents'},{$unwind:'$documents.verifications'},{$group:{_id:{provider:'$documents.verifications.provider',status:'$documents.verifications.status'},attempts:{$sum:1},averageConfidence:{$avg:'$documents.verifications.confidenceScore'}}}]).toArray());
printjson(b.transaction_events.aggregate([{$match:{currency:'NGN',transactionStatus:'POSTED'}},{$group:{_id:'$eventType',eventCount:{$sum:1},totalAmountNGN:{$sum:'$amount'}}}]).toArray());
