const b=db.getSiblingDB('blitzfintech_nosql');
function expectReject(label, fn){try{fn();print('UNEXPECTED PASS: '+label)}catch(e){print('EXPECTED REJECTION '+label+': '+e.codeName+' '+e.message)}}
expectReject('USD forbidden',()=>b.transaction_events.insertOne({eventId:'BF-INVALID-USD',transactionId:NumberLong('999'),transactionReference:'INVALID',accountId:NumberLong('1'),eventType:'TRANSFER',amount:NumberDecimal('100.0000'),currency:'USD',transactionStatus:'POSTED',createdAt:new Date()}));
expectReject('bad risk enum',()=>b.kyc_profiles.insertOne({customerId:NumberLong('999'),kycCaseId:NumberLong('999'),customerNumber:'INVALID',status:'APPROVED',riskRating:'MEDIUM',documents:[],updatedAt:new Date()}));
expectReject('missing required eventId',()=>b.compliance_events.insertOne({customerId:NumberLong('999'),eventType:'TEST',severity:'LOW',source:'TEST',createdAt:new Date()}));
print('Review output: expected rejection does not equal an executed test pass until run.');
