// Run after sample inserts. Demonstrates bounded nested array updates.
const b=db.getSiblingDB('blitzfintech_nosql');
printjson(b.kyc_profiles.updateOne({kycCaseId:NumberLong('2'),'documents.documentId':NumberLong('2')},{$push:{'documents.$.verifications':{method:'REGISTRY_CHECK',provider:'DEMO_PROVIDER',status:'PASSED',verifiedAt:new Date(),providerDetails:{registryMatch:true}}},$set:{updatedAt:new Date()}}));
printjson(b.kyc_profiles.updateOne({kycCaseId:NumberLong('1')},{$set:{'documents.$[doc].verifications.$[ver].reviewNote':'Checked by portfolio reviewer',updatedAt:new Date()}},{arrayFilters:[{'doc.documentId':NumberLong('1')},{'ver.method':'DOCUMENT_AUTHENTICITY'}]}));
printjson(b.kyc_profiles.updateOne({kycCaseId:NumberLong('2')},{$set:{status:'APPROVED',riskRating:'LOW',updatedAt:new Date()}}));
// Demonstration only: these changes do NOT update MySQL kyc_case or customer.
