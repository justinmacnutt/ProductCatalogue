/****** Object:  ForeignKey [FK_AccommodationOccupancy_productId]    Script Date: 08/16/2013 11:33:26 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccommodationOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccommodationOccupancy]'))
ALTER TABLE [dbo].[AccommodationOccupancy] DROP CONSTRAINT [FK_AccommodationOccupancy_productId]
GO
/****** Object:  ForeignKey [FK_Address_addressTypeId]    Script Date: 08/16/2013 11:33:27 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_addressTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] DROP CONSTRAINT [FK_Address_addressTypeId]
GO
/****** Object:  ForeignKey [FK_Address_provinceStateId]    Script Date: 08/16/2013 11:33:27 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_provinceStateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] DROP CONSTRAINT [FK_Address_provinceStateId]
GO
/****** Object:  ForeignKey [FK_Attribute_attributeGroupId]    Script Date: 08/16/2013 11:33:29 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute]'))
ALTER TABLE [dbo].[Attribute] DROP CONSTRAINT [FK_Attribute_attributeGroupId]
GO
/****** Object:  ForeignKey [FK_AttributeGroupProductType_attributeGroupId]    Script Date: 08/16/2013 11:33:32 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType] DROP CONSTRAINT [FK_AttributeGroupProductType_attributeGroupId]
GO
/****** Object:  ForeignKey [FK_AttributeGroupProductType_productTypeId]    Script Date: 08/16/2013 11:33:32 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType] DROP CONSTRAINT [FK_AttributeGroupProductType_productTypeId]
GO
/****** Object:  ForeignKey [FK_BusinessAddress_addressId]    Script Date: 08/16/2013 11:33:35 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress] DROP CONSTRAINT [FK_BusinessAddress_addressId]
GO
/****** Object:  ForeignKey [FK_BusinessAddress_businessId]    Script Date: 08/16/2013 11:33:35 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress] DROP CONSTRAINT [FK_BusinessAddress_businessId]
GO
/****** Object:  ForeignKey [FK_BusinessNote_businessId]    Script Date: 08/16/2013 11:33:36 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote] DROP CONSTRAINT [FK_BusinessNote_businessId]
GO
/****** Object:  ForeignKey [FK_BusinessNote_noteId]    Script Date: 08/16/2013 11:33:36 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote] DROP CONSTRAINT [FK_BusinessNote_noteId]
GO
/****** Object:  ForeignKey [FK_CampgroundOccupancy_productId]    Script Date: 08/16/2013 11:33:38 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampgroundOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampgroundOccupancy]'))
ALTER TABLE [dbo].[CampgroundOccupancy] DROP CONSTRAINT [FK_CampgroundOccupancy_productId]
GO
/****** Object:  ForeignKey [FK_Contact_businessId]    Script Date: 08/16/2013 11:33:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact] DROP CONSTRAINT [FK_Contact_businessId]
GO
/****** Object:  ForeignKey [FK_Contact_contactTypeId]    Script Date: 08/16/2013 11:33:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact] DROP CONSTRAINT [FK_Contact_contactTypeId]
GO
/****** Object:  ForeignKey [FK_ContactAddress_addressId]    Script Date: 08/16/2013 11:33:40 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress] DROP CONSTRAINT [FK_ContactAddress_addressId]
GO
/****** Object:  ForeignKey [FK_ContactAddress_contactId]    Script Date: 08/16/2013 11:33:40 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress] DROP CONSTRAINT [FK_ContactAddress_contactId]
GO
/****** Object:  ForeignKey [FK_ContactNote_contactId]    Script Date: 08/16/2013 11:33:42 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote] DROP CONSTRAINT [FK_ContactNote_contactId]
GO
/****** Object:  ForeignKey [FK_ContactNote_noteId]    Script Date: 08/16/2013 11:33:42 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote] DROP CONSTRAINT [FK_ContactNote_noteId]
GO
/****** Object:  ForeignKey [FK_ContactPhone_contactId]    Script Date: 08/16/2013 11:33:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone] DROP CONSTRAINT [FK_ContactPhone_contactId]
GO
/****** Object:  ForeignKey [FK_ContactPhone_phoneId]    Script Date: 08/16/2013 11:33:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_phoneId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone] DROP CONSTRAINT [FK_ContactPhone_phoneId]
GO
/****** Object:  ForeignKey [FK_ContactProduct_contactId]    Script Date: 08/16/2013 11:33:45 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] DROP CONSTRAINT [FK_ContactProduct_contactId]
GO
/****** Object:  ForeignKey [FK_ContactProduct_contactTypeId]    Script Date: 08/16/2013 11:33:45 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] DROP CONSTRAINT [FK_ContactProduct_contactTypeId]
GO
/****** Object:  ForeignKey [FK_ContactProduct_productId]    Script Date: 08/16/2013 11:33:45 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] DROP CONSTRAINT [FK_ContactProduct_productId]
GO
/****** Object:  ForeignKey [FK_Media_mediaLanguageId]    Script Date: 08/16/2013 11:33:46 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaLanguageId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] DROP CONSTRAINT [FK_Media_mediaLanguageId]
GO
/****** Object:  ForeignKey [FK_Media_mediaTypeId]    Script Date: 08/16/2013 11:33:46 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] DROP CONSTRAINT [FK_Media_mediaTypeId]
GO
/****** Object:  ForeignKey [FK_Media_productId]    Script Date: 08/16/2013 11:33:46 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] DROP CONSTRAINT [FK_Media_productId]
GO
/****** Object:  ForeignKey [FK_MediaTranslation_mediaId]    Script Date: 08/16/2013 11:33:48 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MediaTranslation_mediaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[MediaTranslation]'))
ALTER TABLE [dbo].[MediaTranslation] DROP CONSTRAINT [FK_MediaTranslation_mediaId]
GO
/****** Object:  ForeignKey [FK_OperationPeriod_productId]    Script Date: 08/16/2013 11:33:51 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OperationPeriod_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[OperationPeriod]'))
ALTER TABLE [dbo].[OperationPeriod] DROP CONSTRAINT [FK_OperationPeriod_productId]
GO
/****** Object:  ForeignKey [FK_Phone_phoneTypeId]    Script Date: 08/16/2013 11:33:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Phone_phoneTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Phone]'))
ALTER TABLE [dbo].[Phone] DROP CONSTRAINT [FK_Phone_phoneTypeId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_cancellationPolicyId]    Script Date: 08/16/2013 11:33:54 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_cancellationPolicyId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_periodOfOperationTypeId]    Script Date: 08/16/2013 11:33:54 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_periodOfOperationTypeId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_productId]    Script Date: 08/16/2013 11:33:54 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_productId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_ratePeriodId]    Script Date: 08/16/2013 11:33:54 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_ratePeriodId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_rateTypeId]    Script Date: 08/16/2013 11:33:54 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_rateTypeId]
GO
/****** Object:  ForeignKey [FK_PrintVersionTranslation_productId]    Script Date: 08/16/2013 11:33:55 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersionTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersionTranslation]'))
ALTER TABLE [dbo].[PrintVersionTranslation] DROP CONSTRAINT [FK_PrintVersionTranslation_productId]
GO
/****** Object:  ForeignKey [FK_Product_cancellationPolicyId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_cancellationPolicyId]
GO
/****** Object:  ForeignKey [FK_Product_capacityTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_capacityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_capacityTypeId]
GO
/****** Object:  ForeignKey [FK_Product_communityId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_communityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_communityId]
GO
/****** Object:  ForeignKey [FK_Product_ownershipTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ownershipTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_ownershipTypeId]
GO
/****** Object:  ForeignKey [FK_Product_periodOfOperationTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_periodOfOperationTypeId]
GO
/****** Object:  ForeignKey [FK_Product_primaryGuideSectionId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_primaryGuideSectionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_primaryGuideSectionId]
GO
/****** Object:  ForeignKey [FK_Product_productTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_productTypeId]
GO
/****** Object:  ForeignKey [FK_Product_ratePeriodId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_ratePeriodId]
GO
/****** Object:  ForeignKey [FK_Product_rateTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_rateTypeId]
GO
/****** Object:  ForeignKey [FK_Product_subRegionId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_subRegionId]
GO
/****** Object:  ForeignKey [FK_Product_sustainabilityTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_sustainabilityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_sustainabilityTypeId]
GO
/****** Object:  ForeignKey [FK_Product_tollfreeAreaId]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_tollfreeAreaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_tollfreeAreaId]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_Attribute]    Script Date: 08/16/2013 11:33:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Attribute]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_Attribute]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_attributeGroupId]    Script Date: 08/16/2013 11:33:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_attributeGroupId]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_Product]    Script Date: 08/16/2013 11:33:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Product]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_Product]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_productTypeId]    Script Date: 08/16/2013 11:33:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_productTypeId]
GO
/****** Object:  ForeignKey [FK_ProductCaaRating_caaRatingTypeId]    Script Date: 08/16/2013 11:34:00 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_caaRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating] DROP CONSTRAINT [FK_ProductCaaRating_caaRatingTypeId]
GO
/****** Object:  ForeignKey [FK_ProductCaaRating_productId]    Script Date: 08/16/2013 11:34:00 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating] DROP CONSTRAINT [FK_ProductCaaRating_productId]
GO
/****** Object:  ForeignKey [FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]    Script Date: 08/16/2013 11:34:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating] DROP CONSTRAINT [FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]
GO
/****** Object:  ForeignKey [FK_ProductCanadaSelectRating_productId]    Script Date: 08/16/2013 11:34:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating] DROP CONSTRAINT [FK_ProductCanadaSelectRating_productId]
GO
/****** Object:  ForeignKey [FK_ProductDescription_ProductDescription]    Script Date: 08/16/2013 11:34:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_ProductDescription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] DROP CONSTRAINT [FK_ProductDescription_ProductDescription]
GO
/****** Object:  ForeignKey [FK_ProductDescription_productId]    Script Date: 08/16/2013 11:34:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] DROP CONSTRAINT [FK_ProductDescription_productId]
GO
/****** Object:  ForeignKey [FK_ProductDescription_descriptionTypeId]    Script Date: 08/16/2013 11:34:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_descriptionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] DROP CONSTRAINT [FK_ProductDescription_descriptionType]
GO
/****** Object:  ForeignKey [FK_ProductNote_noteId]    Script Date: 08/16/2013 11:34:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote] DROP CONSTRAINT [FK_ProductNote_noteId]
GO
/****** Object:  ForeignKey [FK_ProductNote_productId]    Script Date: 08/16/2013 11:34:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote] DROP CONSTRAINT [FK_ProductNote_productId]
GO
/****** Object:  ForeignKey [FK_ProductPaymentType_paymentTypeId]    Script Date: 08/16/2013 11:34:06 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_paymentTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType] DROP CONSTRAINT [FK_ProductPaymentType_paymentTypeId]
GO
/****** Object:  ForeignKey [FK_ProductPaymentType_productId]    Script Date: 08/16/2013 11:34:06 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType] DROP CONSTRAINT [FK_ProductPaymentType_productId]
GO
/****** Object:  ForeignKey [FK_ProductRegionOfOperation_productId]    Script Date: 08/16/2013 11:34:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation] DROP CONSTRAINT [FK_ProductRegionOfOperation_productId]
GO
/****** Object:  ForeignKey [FK_ProductRegionOfOperation_regionId]    Script Date: 08/16/2013 11:34:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation] DROP CONSTRAINT [FK_ProductRegionOfOperation_regionId]
GO
/****** Object:  ForeignKey [FK_ProductTranslation_productId]    Script Date: 08/16/2013 11:34:09 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductTranslation]'))
ALTER TABLE [dbo].[ProductTranslation] DROP CONSTRAINT [FK_ProductTranslation_productId]
GO
/****** Object:  ForeignKey [FK_ProductUnitNumber_productId]    Script Date: 08/16/2013 11:34:10 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber] DROP CONSTRAINT [FK_ProductUnitNumber_productId]
GO
/****** Object:  ForeignKey [FK_ProductUnitNumber_unitTypeId]    Script Date: 08/16/2013 11:34:10 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_unitTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber] DROP CONSTRAINT [FK_ProductUnitNumber_unitTypeId]
GO
/****** Object:  ForeignKey [FK_refCommunity_countyId]    Script Date: 08/16/2013 11:34:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_countyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] DROP CONSTRAINT [FK_refCommunity_countyId]
GO
/****** Object:  ForeignKey [FK_refCommunity_regionId]    Script Date: 08/16/2013 11:34:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] DROP CONSTRAINT [FK_refCommunity_regionId]
GO
/****** Object:  ForeignKey [FK_refCommunity_subRegionId]    Script Date: 08/16/2013 11:34:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] DROP CONSTRAINT [FK_refCommunity_subRegionId]
GO
/****** Object:  ForeignKey [FK_TranslationStatus_fieldId]    Script Date: 08/16/2013 11:35:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_fieldId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus] DROP CONSTRAINT [FK_TranslationStatus_fieldId]
GO
/****** Object:  ForeignKey [FK_TranslationStatus_productId]    Script Date: 08/16/2013 11:35:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus] DROP CONSTRAINT [FK_TranslationStatus_productId]
GO
/****** Object:  ForeignKey [FK_Url_productId]    Script Date: 08/16/2013 11:35:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url] DROP CONSTRAINT [FK_Url_productId]
GO
/****** Object:  ForeignKey [FK_Url_urlTypeId]    Script Date: 08/16/2013 11:35:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_urlTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url] DROP CONSTRAINT [FK_Url_urlTypeId]
GO
/****** Object:  ForeignKey [FK_UrlTranslation_urlId]    Script Date: 08/16/2013 11:35:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UrlTranslation_urlId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UrlTranslation]'))
ALTER TABLE [dbo].[UrlTranslation] DROP CONSTRAINT [FK_UrlTranslation_urlId]
GO
/****** Object:  ForeignKey [FK_UserProfileRole_profileId]    Script Date: 08/16/2013 11:35:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_profileId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole] DROP CONSTRAINT [FK_UserProfileRole_profileId]
GO
/****** Object:  ForeignKey [FK_UserProfileRole_roleId]    Script Date: 08/16/2013 11:35:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_roleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole] DROP CONSTRAINT [FK_UserProfileRole_roleId]
GO
/****** Object:  Table [dbo].[MediaTranslation]    Script Date: 08/16/2013 11:33:48 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MediaTranslation_mediaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[MediaTranslation]'))
ALTER TABLE [dbo].[MediaTranslation] DROP CONSTRAINT [FK_MediaTranslation_mediaId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MediaTranslation]') AND type in (N'U'))
DROP TABLE [dbo].[MediaTranslation]
GO
/****** Object:  Table [dbo].[UrlTranslation]    Script Date: 08/16/2013 11:35:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UrlTranslation_urlId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UrlTranslation]'))
ALTER TABLE [dbo].[UrlTranslation] DROP CONSTRAINT [FK_UrlTranslation_urlId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UrlTranslation]') AND type in (N'U'))
DROP TABLE [dbo].[UrlTranslation]
GO
/****** Object:  Table [dbo].[TranslationStatus]    Script Date: 08/16/2013 11:35:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_fieldId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus] DROP CONSTRAINT [FK_TranslationStatus_fieldId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus] DROP CONSTRAINT [FK_TranslationStatus_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TranslationStatus]') AND type in (N'U'))
DROP TABLE [dbo].[TranslationStatus]
GO
/****** Object:  Table [dbo].[Url]    Script Date: 08/16/2013 11:35:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url] DROP CONSTRAINT [FK_Url_productId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_urlTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url] DROP CONSTRAINT [FK_Url_urlTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Url]') AND type in (N'U'))
DROP TABLE [dbo].[Url]
GO
/****** Object:  Table [dbo].[ContactProduct]    Script Date: 08/16/2013 11:33:45 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] DROP CONSTRAINT [FK_ContactProduct_contactId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] DROP CONSTRAINT [FK_ContactProduct_contactTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] DROP CONSTRAINT [FK_ContactProduct_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactProduct]') AND type in (N'U'))
DROP TABLE [dbo].[ContactProduct]
GO
/****** Object:  Table [dbo].[Media]    Script Date: 08/16/2013 11:33:46 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaLanguageId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] DROP CONSTRAINT [FK_Media_mediaLanguageId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] DROP CONSTRAINT [FK_Media_mediaTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] DROP CONSTRAINT [FK_Media_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Media]') AND type in (N'U'))
DROP TABLE [dbo].[Media]
GO
/****** Object:  Table [dbo].[OperationPeriod]    Script Date: 08/16/2013 11:33:51 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OperationPeriod_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[OperationPeriod]'))
ALTER TABLE [dbo].[OperationPeriod] DROP CONSTRAINT [FK_OperationPeriod_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperationPeriod]') AND type in (N'U'))
DROP TABLE [dbo].[OperationPeriod]
GO
/****** Object:  Table [dbo].[ProductAttribute]    Script Date: 08/16/2013 11:33:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Attribute]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_Attribute]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_attributeGroupId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Product]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_Product]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] DROP CONSTRAINT [FK_ProductAttribute_productTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductAttribute]') AND type in (N'U'))
DROP TABLE [dbo].[ProductAttribute]
GO
/****** Object:  Table [dbo].[ProductCaaRating]    Script Date: 08/16/2013 11:34:00 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_caaRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating] DROP CONSTRAINT [FK_ProductCaaRating_caaRatingTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating] DROP CONSTRAINT [FK_ProductCaaRating_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]') AND type in (N'U'))
DROP TABLE [dbo].[ProductCaaRating]
GO
/****** Object:  Table [dbo].[ProductCanadaSelectRating]    Script Date: 08/16/2013 11:34:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating] DROP CONSTRAINT [FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating] DROP CONSTRAINT [FK_ProductCanadaSelectRating_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]') AND type in (N'U'))
DROP TABLE [dbo].[ProductCanadaSelectRating]
GO
/****** Object:  Table [dbo].[ProductDescription]    Script Date: 08/16/2013 11:34:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_ProductDescription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] DROP CONSTRAINT [FK_ProductDescription_ProductDescription]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] DROP CONSTRAINT [FK_ProductDescription_productId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_descriptionTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] DROP CONSTRAINT [FK_ProductDescription_descriptionTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductDescription]') AND type in (N'U'))
DROP TABLE [dbo].[ProductDescription]
GO
/****** Object:  Table [dbo].[ProductNote]    Script Date: 08/16/2013 11:34:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote] DROP CONSTRAINT [FK_ProductNote_noteId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote] DROP CONSTRAINT [FK_ProductNote_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductNote]') AND type in (N'U'))
DROP TABLE [dbo].[ProductNote]
GO
/****** Object:  Table [dbo].[ProductPaymentType]    Script Date: 08/16/2013 11:34:06 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_paymentTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType] DROP CONSTRAINT [FK_ProductPaymentType_paymentTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType] DROP CONSTRAINT [FK_ProductPaymentType_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]') AND type in (N'U'))
DROP TABLE [dbo].[ProductPaymentType]
GO
/****** Object:  Table [dbo].[ProductRegionOfOperation]    Script Date: 08/16/2013 11:34:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation] DROP CONSTRAINT [FK_ProductRegionOfOperation_productId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation] DROP CONSTRAINT [FK_ProductRegionOfOperation_regionId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]') AND type in (N'U'))
DROP TABLE [dbo].[ProductRegionOfOperation]
GO
/****** Object:  Table [dbo].[ProductTranslation]    Script Date: 08/16/2013 11:34:09 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductTranslation]'))
ALTER TABLE [dbo].[ProductTranslation] DROP CONSTRAINT [FK_ProductTranslation_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductTranslation]') AND type in (N'U'))
DROP TABLE [dbo].[ProductTranslation]
GO
/****** Object:  Table [dbo].[ProductUnitNumber]    Script Date: 08/16/2013 11:34:10 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber] DROP CONSTRAINT [FK_ProductUnitNumber_productId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_unitTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber] DROP CONSTRAINT [FK_ProductUnitNumber_unitTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]') AND type in (N'U'))
DROP TABLE [dbo].[ProductUnitNumber]
GO
/****** Object:  Table [dbo].[AccommodationOccupancy]    Script Date: 08/16/2013 11:33:26 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccommodationOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccommodationOccupancy]'))
ALTER TABLE [dbo].[AccommodationOccupancy] DROP CONSTRAINT [FK_AccommodationOccupancy_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccommodationOccupancy]') AND type in (N'U'))
DROP TABLE [dbo].[AccommodationOccupancy]
GO
/****** Object:  Table [dbo].[CampgroundOccupancy]    Script Date: 08/16/2013 11:33:38 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampgroundOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampgroundOccupancy]'))
ALTER TABLE [dbo].[CampgroundOccupancy] DROP CONSTRAINT [FK_CampgroundOccupancy_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CampgroundOccupancy]') AND type in (N'U'))
DROP TABLE [dbo].[CampgroundOccupancy]
GO
/****** Object:  Table [dbo].[PrintVersion]    Script Date: 08/16/2013 11:33:54 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_cancellationPolicyId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_periodOfOperationTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_productId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_ratePeriodId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [FK_PrintVersion_rateTypeId]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PrintVersion_periodOfOperationTypeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [DF_PrintVersion_periodOfOperationTypeId]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PrintVersion_hasOffSeasonDates]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PrintVersion] DROP CONSTRAINT [DF_PrintVersion_hasOffSeasonDates]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrintVersion]') AND type in (N'U'))
DROP TABLE [dbo].[PrintVersion]
GO
/****** Object:  Table [dbo].[PrintVersionTranslation]    Script Date: 08/16/2013 11:33:55 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersionTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersionTranslation]'))
ALTER TABLE [dbo].[PrintVersionTranslation] DROP CONSTRAINT [FK_PrintVersionTranslation_productId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrintVersionTranslation]') AND type in (N'U'))
DROP TABLE [dbo].[PrintVersionTranslation]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 08/16/2013 11:33:57 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_cancellationPolicyId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_capacityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_capacityTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_communityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_communityId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ownershipTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_ownershipTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_periodOfOperationTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_primaryGuideSectionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_primaryGuideSectionId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_productTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_ratePeriodId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_rateTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_subRegionId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_sustainabilityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_sustainabilityTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_tollfreeAreaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Product_tollfreeAreaId]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isCheckinMember]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isCheckinMember]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_periodOfOperationTypeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_periodOfOperationTypeId]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isOpenAllYear]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isOpenAllYear]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_hasOffSeasonDates]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_hasOffSeasonDates]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_noTax]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_noTax]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_paymentReceived]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_paymentReceived]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isTicketed]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isTicketed]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isValid]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isValid]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isComplete]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isComplete]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isActive]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_overrideErrors]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_overrideErrors]
END
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Product_isDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_isDeleted]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND type in (N'U'))
DROP TABLE [dbo].[Product]
GO
/****** Object:  Table [dbo].[BusinessAddress]    Script Date: 08/16/2013 11:33:35 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress] DROP CONSTRAINT [FK_BusinessAddress_addressId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress] DROP CONSTRAINT [FK_BusinessAddress_businessId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BusinessAddress]') AND type in (N'U'))
DROP TABLE [dbo].[BusinessAddress]
GO
/****** Object:  Table [dbo].[ContactAddress]    Script Date: 08/16/2013 11:33:40 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress] DROP CONSTRAINT [FK_ContactAddress_addressId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress] DROP CONSTRAINT [FK_ContactAddress_contactId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactAddress]') AND type in (N'U'))
DROP TABLE [dbo].[ContactAddress]
GO
/****** Object:  Table [dbo].[ContactNote]    Script Date: 08/16/2013 11:33:42 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote] DROP CONSTRAINT [FK_ContactNote_contactId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote] DROP CONSTRAINT [FK_ContactNote_noteId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactNote]') AND type in (N'U'))
DROP TABLE [dbo].[ContactNote]
GO
/****** Object:  Table [dbo].[ContactPhone]    Script Date: 08/16/2013 11:33:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone] DROP CONSTRAINT [FK_ContactPhone_contactId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_phoneId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone] DROP CONSTRAINT [FK_ContactPhone_phoneId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactPhone]') AND type in (N'U'))
DROP TABLE [dbo].[ContactPhone]
GO
/****** Object:  Table [dbo].[BusinessNote]    Script Date: 08/16/2013 11:33:36 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote] DROP CONSTRAINT [FK_BusinessNote_businessId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote] DROP CONSTRAINT [FK_BusinessNote_noteId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BusinessNote]') AND type in (N'U'))
DROP TABLE [dbo].[BusinessNote]
GO
/****** Object:  Table [dbo].[Phone]    Script Date: 08/16/2013 11:33:52 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Phone_phoneTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Phone]'))
ALTER TABLE [dbo].[Phone] DROP CONSTRAINT [FK_Phone_phoneTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Phone]') AND type in (N'U'))
DROP TABLE [dbo].[Phone]
GO
/****** Object:  Table [dbo].[UserProfileRole]    Script Date: 08/16/2013 11:35:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_profileId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole] DROP CONSTRAINT [FK_UserProfileRole_profileId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_roleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole] DROP CONSTRAINT [FK_UserProfileRole_roleId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserProfileRole]') AND type in (N'U'))
DROP TABLE [dbo].[UserProfileRole]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 08/16/2013 11:33:39 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact] DROP CONSTRAINT [FK_Contact_businessId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact] DROP CONSTRAINT [FK_Contact_contactTypeId]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Contact_isDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Contact] DROP CONSTRAINT [DF_Contact_isDeleted]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact]') AND type in (N'U'))
DROP TABLE [dbo].[Contact]
GO
/****** Object:  Table [dbo].[AttributeGroupProductType]    Script Date: 08/16/2013 11:33:32 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType] DROP CONSTRAINT [FK_AttributeGroupProductType_attributeGroupId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType] DROP CONSTRAINT [FK_AttributeGroupProductType_productTypeId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]') AND type in (N'U'))
DROP TABLE [dbo].[AttributeGroupProductType]
GO
/****** Object:  Table [dbo].[Address]    Script Date: 08/16/2013 11:33:27 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_addressTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] DROP CONSTRAINT [FK_Address_addressTypeId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_provinceStateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] DROP CONSTRAINT [FK_Address_provinceStateId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address]') AND type in (N'U'))
DROP TABLE [dbo].[Address]
GO
/****** Object:  Table [dbo].[Attribute]    Script Date: 08/16/2013 11:33:29 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute]'))
ALTER TABLE [dbo].[Attribute] DROP CONSTRAINT [FK_Attribute_attributeGroupId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attribute]') AND type in (N'U'))
DROP TABLE [dbo].[Attribute]
GO
/****** Object:  Table [dbo].[refCommunity]    Script Date: 08/16/2013 11:34:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_countyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] DROP CONSTRAINT [FK_refCommunity_countyId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] DROP CONSTRAINT [FK_refCommunity_regionId]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] DROP CONSTRAINT [FK_refCommunity_subRegionId]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCommunity]') AND type in (N'U'))
DROP TABLE [dbo].[refCommunity]
GO
/****** Object:  Table [dbo].[refContactType]    Script Date: 08/16/2013 11:34:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refContactType]') AND type in (N'U'))
DROP TABLE [dbo].[refContactType]
GO
/****** Object:  Table [dbo].[refCountry]    Script Date: 08/16/2013 11:34:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCountry]') AND type in (N'U'))
DROP TABLE [dbo].[refCountry]
GO
/****** Object:  Table [dbo].[refCounty]    Script Date: 08/16/2013 11:34:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCounty]') AND type in (N'U'))
DROP TABLE [dbo].[refCounty]
GO
/****** Object:  Table [dbo].[refCreditCard]    Script Date: 08/16/2013 11:34:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCreditCard]') AND type in (N'U'))
DROP TABLE [dbo].[refCreditCard]
GO
/****** Object:  Table [dbo].[refDescriptionType]    Script Date: 08/16/2013 11:34:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refDescriptionType]') AND type in (N'U'))
DROP TABLE [dbo].[refDescriptionType]
GO
/****** Object:  Table [dbo].[refGuideSection]    Script Date: 08/16/2013 11:34:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refGuideSection]') AND type in (N'U'))
DROP TABLE [dbo].[refGuideSection]
GO
/****** Object:  Table [dbo].[refMediaLanguage]    Script Date: 08/16/2013 11:34:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refMediaLanguage]') AND type in (N'U'))
DROP TABLE [dbo].[refMediaLanguage]
GO
/****** Object:  Table [dbo].[refMediaType]    Script Date: 08/16/2013 11:34:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refMediaType]') AND type in (N'U'))
DROP TABLE [dbo].[refMediaType]
GO
/****** Object:  Table [dbo].[refOwnershipType]    Script Date: 08/16/2013 11:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refOwnershipType]') AND type in (N'U'))
DROP TABLE [dbo].[refOwnershipType]
GO
/****** Object:  Table [dbo].[refPaymentType]    Script Date: 08/16/2013 11:34:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refPaymentType]') AND type in (N'U'))
DROP TABLE [dbo].[refPaymentType]
GO
/****** Object:  Table [dbo].[refPeriodOfOperationType]    Script Date: 08/16/2013 11:34:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refPeriodOfOperationType]') AND type in (N'U'))
DROP TABLE [dbo].[refPeriodOfOperationType]
GO
/****** Object:  Table [dbo].[refPhoneType]    Script Date: 08/16/2013 11:34:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refPhoneType]') AND type in (N'U'))
DROP TABLE [dbo].[refPhoneType]
GO
/****** Object:  Table [dbo].[refProductField]    Script Date: 08/16/2013 11:34:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refProductField]') AND type in (N'U'))
DROP TABLE [dbo].[refProductField]
GO
/****** Object:  Table [dbo].[refProductType]    Script Date: 08/16/2013 11:34:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refProductType]') AND type in (N'U'))
DROP TABLE [dbo].[refProductType]
GO
/****** Object:  Table [dbo].[refProvinceState]    Script Date: 08/16/2013 11:34:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refProvinceState]') AND type in (N'U'))
DROP TABLE [dbo].[refProvinceState]
GO
/****** Object:  Table [dbo].[refRatePeriod]    Script Date: 08/16/2013 11:34:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refRatePeriod]') AND type in (N'U'))
DROP TABLE [dbo].[refRatePeriod]
GO
/****** Object:  Table [dbo].[refRateType]    Script Date: 08/16/2013 11:34:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refRateType]') AND type in (N'U'))
DROP TABLE [dbo].[refRateType]
GO
/****** Object:  Table [dbo].[refRegion]    Script Date: 08/16/2013 11:34:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refRegion]') AND type in (N'U'))
DROP TABLE [dbo].[refRegion]
GO
/****** Object:  Table [dbo].[refSubRegion]    Script Date: 08/16/2013 11:34:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refSubRegion]') AND type in (N'U'))
DROP TABLE [dbo].[refSubRegion]
GO
/****** Object:  Table [dbo].[refSustainabilityType]    Script Date: 08/16/2013 11:34:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refSustainabilityType]') AND type in (N'U'))
DROP TABLE [dbo].[refSustainabilityType]
GO
/****** Object:  Table [dbo].[refTollfreeArea]    Script Date: 08/16/2013 11:34:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refTollfreeArea]') AND type in (N'U'))
DROP TABLE [dbo].[refTollfreeArea]
GO
/****** Object:  Table [dbo].[refUnitType]    Script Date: 08/16/2013 11:34:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refUnitType]') AND type in (N'U'))
DROP TABLE [dbo].[refUnitType]
GO
/****** Object:  Table [dbo].[refUrlType]    Script Date: 08/16/2013 11:34:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refUrlType]') AND type in (N'U'))
DROP TABLE [dbo].[refUrlType]
GO
/****** Object:  Table [dbo].[refVersionHistoryType]    Script Date: 08/16/2013 11:34:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refVersionHistoryType]') AND type in (N'U'))
DROP TABLE [dbo].[refVersionHistoryType]
GO
/****** Object:  Table [dbo].[RegionSubRegion]    Script Date: 08/16/2013 11:35:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RegionSubRegion]') AND type in (N'U'))
DROP TABLE [dbo].[RegionSubRegion]
GO
/****** Object:  Table [dbo].[AttributeGroup]    Script Date: 08/16/2013 11:33:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttributeGroup]') AND type in (N'U'))
DROP TABLE [dbo].[AttributeGroup]
GO
/****** Object:  Table [dbo].[Business]    Script Date: 08/16/2013 11:33:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Business_isDeleted]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Business] DROP CONSTRAINT [DF_Business_isDeleted]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Business]') AND type in (N'U'))
DROP TABLE [dbo].[Business]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 08/16/2013 11:35:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRole]') AND type in (N'U'))
DROP TABLE [dbo].[UserRole]
GO
/****** Object:  Table [dbo].[VersionHistory]    Script Date: 08/16/2013 11:35:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VersionHistory]') AND type in (N'U'))
DROP TABLE [dbo].[VersionHistory]
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 08/16/2013 11:35:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserProfile]') AND type in (N'U'))
DROP TABLE [dbo].[UserProfile]
GO
/****** Object:  Table [dbo].[Note]    Script Date: 08/16/2013 11:33:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Note]') AND type in (N'U'))
DROP TABLE [dbo].[Note]
GO
/****** Object:  Table [dbo].[refAction]    Script Date: 08/16/2013 11:34:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refAction]') AND type in (N'U'))
DROP TABLE [dbo].[refAction]
GO
/****** Object:  Table [dbo].[refAddressType]    Script Date: 08/16/2013 11:34:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refAddressType]') AND type in (N'U'))
DROP TABLE [dbo].[refAddressType]
GO
/****** Object:  Table [dbo].[refArchiveType]    Script Date: 08/16/2013 11:34:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refArchiveType]') AND type in (N'U'))
DROP TABLE [dbo].[refArchiveType]
GO
/****** Object:  Table [dbo].[refCaaRatingType]    Script Date: 08/16/2013 11:34:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCaaRatingType]') AND type in (N'U'))
DROP TABLE [dbo].[refCaaRatingType]
GO
/****** Object:  Table [dbo].[refCanadaSelectRatingType]    Script Date: 08/16/2013 11:34:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCanadaSelectRatingType]') AND type in (N'U'))
DROP TABLE [dbo].[refCanadaSelectRatingType]
GO
/****** Object:  Table [dbo].[refCancellationPolicy]    Script Date: 08/16/2013 11:34:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCancellationPolicy]') AND type in (N'U'))
DROP TABLE [dbo].[refCancellationPolicy]
GO
/****** Object:  Table [dbo].[refCapacityType]    Script Date: 08/16/2013 11:34:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCapacityType]') AND type in (N'U'))
DROP TABLE [dbo].[refCapacityType]
GO
/****** Object:  Table [dbo].[refCapacityType]    Script Date: 08/16/2013 11:34:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCapacityType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCapacityType](
	[id] [tinyint] NOT NULL,
	[capacityTypeName] [nvarchar](100) NULL,
 CONSTRAINT [PK_refCapacityType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refCancellationPolicy]    Script Date: 08/16/2013 11:34:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCancellationPolicy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCancellationPolicy](
	[id] [tinyint] NOT NULL,
	[cancellationPolicyName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_refCancellationPolicy] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refCanadaSelectRatingType]    Script Date: 08/16/2013 11:34:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCanadaSelectRatingType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCanadaSelectRatingType](
	[id] [tinyint] NOT NULL,
	[canadaSelectRatingTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_refCanadaSelectRatingType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refCaaRatingType]    Script Date: 08/16/2013 11:34:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCaaRatingType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCaaRatingType](
	[id] [tinyint] NOT NULL,
	[caaRatingTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_refCaaRatingType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refArchiveType]    Script Date: 08/16/2013 11:34:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refArchiveType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refArchiveType](
	[id] [tinyint] NOT NULL,
	[archiveTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_refArchiveType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refAddressType]    Script Date: 08/16/2013 11:34:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refAddressType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refAddressType](
	[id] [tinyint] NOT NULL,
	[addressTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_refAddressType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refAction]    Script Date: 08/16/2013 11:34:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refAction]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refAction](
	[id] [tinyint] NOT NULL,
	[actionName] [varchar](50) NULL,
 CONSTRAINT [PK_refAction] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Note]    Script Date: 08/16/2013 11:33:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Note]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Note](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[noteBody] [varchar](2000) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[reminderDate] [datetime] NULL,
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Note] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserProfile]    Script Date: 08/16/2013 11:35:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserProfile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserProfile](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[creationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Profile] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[VersionHistory]    Script Date: 08/16/2013 11:35:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VersionHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VersionHistory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[productId] [int] NOT NULL,
	[secondaryId] [int] NULL,
	[typeId] [tinyint] NOT NULL,
	[actionId] [tinyint] NOT NULL,
	[modifiedBy] [varchar](50) NOT NULL,
	[modificationDate] [datetime] NOT NULL,
	[versionXml] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ProductHistory] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 08/16/2013 11:35:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserRole](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[roleName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Business]    Script Date: 08/16/2013 11:33:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Business]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Business](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[businessName] [nvarchar](300) NULL,
	[description] [nvarchar](1000) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Business_isDeleted]  DEFAULT ((0)),
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Business] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AttributeGroup]    Script Date: 08/16/2013 11:33:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttributeGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AttributeGroup](
	[id] [smallint] NOT NULL,
	[attributeGroupName] [varchar](100) NULL,
 CONSTRAINT [PK_AttributeGroup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RegionSubRegion]    Script Date: 08/16/2013 11:35:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RegionSubRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RegionSubRegion](
	[regionId] [int] NOT NULL,
	[subRegionId] [int] NOT NULL,
 CONSTRAINT [PK_RegionSubRegion] PRIMARY KEY CLUSTERED 
(
	[regionId] ASC,
	[subRegionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refVersionHistoryType]    Script Date: 08/16/2013 11:34:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refVersionHistoryType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refVersionHistoryType](
	[id] [tinyint] NOT NULL,
	[typeName] [varchar](100) NULL,
 CONSTRAINT [PK_refVersionHistoryType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refUrlType]    Script Date: 08/16/2013 11:34:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refUrlType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refUrlType](
	[id] [tinyint] NOT NULL,
	[urlTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_refUrlType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refUnitType]    Script Date: 08/16/2013 11:34:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refUnitType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refUnitType](
	[id] [tinyint] NOT NULL,
	[unitTypeName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_refUnitType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refTollfreeArea]    Script Date: 08/16/2013 11:34:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refTollfreeArea]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refTollfreeArea](
	[id] [tinyint] NOT NULL,
	[tollfreeAreaName] [varchar](50) NULL,
 CONSTRAINT [PK_refTollfreeArea] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refSustainabilityType]    Script Date: 08/16/2013 11:34:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refSustainabilityType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refSustainabilityType](
	[id] [tinyint] NOT NULL,
	[sustainabilityTypeName] [nvarchar](100) NULL,
 CONSTRAINT [PK_refSustainabilityType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refSubRegion]    Script Date: 08/16/2013 11:34:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refSubRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refSubRegion](
	[id] [smallint] NOT NULL,
	[subRegionName] [varchar](100) NULL,
 CONSTRAINT [PK_refSubRegion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refRegion]    Script Date: 08/16/2013 11:34:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refRegion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refRegion](
	[id] [tinyint] NOT NULL,
	[regionName] [varchar](100) NULL,
	[guideSortOrder] [tinyint] NULL,
 CONSTRAINT [PK_refRegion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refRateType]    Script Date: 08/16/2013 11:34:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refRateType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refRateType](
	[id] [tinyint] NOT NULL,
	[rateTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_refRateType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refRatePeriod]    Script Date: 08/16/2013 11:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refRatePeriod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refRatePeriod](
	[id] [tinyint] NOT NULL,
	[ratePeriodName] [varchar](100) NULL,
 CONSTRAINT [PK_refRatePeriode] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refProvinceState]    Script Date: 08/16/2013 11:34:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refProvinceState]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refProvinceState](
	[id] [char](2) NOT NULL,
	[provinceStateName] [varchar](50) NULL,
	[countryId] [char](2) NULL,
 CONSTRAINT [PK_refProvinceState] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refProductType]    Script Date: 08/16/2013 11:34:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refProductType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refProductType](
	[id] [tinyint] NOT NULL,
	[productTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_refProductType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refProductField]    Script Date: 08/16/2013 11:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refProductField]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refProductField](
	[id] [tinyint] NOT NULL,
	[fieldName] [varchar](50) NOT NULL,
	[fieldTypeId] [tinyint] NOT NULL,
 CONSTRAINT [PK_refProductField] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refPhoneType]    Script Date: 08/16/2013 11:34:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refPhoneType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refPhoneType](
	[id] [tinyint] NOT NULL,
	[phoneTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_refPhoneType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refPeriodOfOperationType]    Script Date: 08/16/2013 11:34:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refPeriodOfOperationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refPeriodOfOperationType](
	[id] [tinyint] NOT NULL,
	[periodOfOperationTypeName] [nvarchar](100) NULL,
 CONSTRAINT [PK_refPeriodOfOperationType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refPaymentType]    Script Date: 08/16/2013 11:34:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refPaymentType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refPaymentType](
	[id] [tinyint] NOT NULL,
	[paymentTypeName] [nvarchar](100) NULL,
 CONSTRAINT [PK_refPaymentType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refOwnershipType]    Script Date: 08/16/2013 11:34:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refOwnershipType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refOwnershipType](
	[id] [tinyint] NOT NULL,
	[ownershipTypeName] [nvarchar](100) NULL,
 CONSTRAINT [PK_refOwnershipType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refMediaType]    Script Date: 08/16/2013 11:34:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refMediaType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refMediaType](
	[id] [tinyint] NOT NULL,
	[mediaTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_refMediaType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refMediaLanguage]    Script Date: 08/16/2013 11:34:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refMediaLanguage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refMediaLanguage](
	[id] [tinyint] NOT NULL,
	[mediaLanguageName] [varchar](100) NULL,
 CONSTRAINT [PK_refMediaLanguage] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refGuideSection]    Script Date: 08/16/2013 11:34:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refGuideSection]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refGuideSection](
	[id] [tinyint] NOT NULL,
	[guideSectionName] [varchar](50) NOT NULL,
	[productTypeId] [tinyint] NOT NULL,
	[guideSortOrder] [tinyint] NOT NULL,
 CONSTRAINT [PK_refGuideSection] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refDescriptionType]    Script Date: 08/16/2013 11:34:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refDescriptionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refDescriptionType](
	[id] [tinyint] NOT NULL,
	[descriptionTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_refDescriptionType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refCreditCard]    Script Date: 08/16/2013 11:34:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCreditCard]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCreditCard](
	[id] [tinyint] NOT NULL,
	[creditCardName] [nvarchar](100) NULL,
 CONSTRAINT [PK_refCreditCard] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[refCounty]    Script Date: 08/16/2013 11:34:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCounty]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCounty](
	[id] [tinyint] NOT NULL,
	[countyName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_refCounty] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refCountry]    Script Date: 08/16/2013 11:34:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCountry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCountry](
	[id] [varchar](3) NOT NULL,
	[countryName] [varchar](100) NULL,
 CONSTRAINT [PK_refCountry] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refContactType]    Script Date: 08/16/2013 11:34:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refContactType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refContactType](
	[id] [tinyint] NOT NULL,
	[contactTypeName] [varchar](100) NULL,
 CONSTRAINT [PK_refContactType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[refCommunity]    Script Date: 08/16/2013 11:34:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[refCommunity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[refCommunity](
	[id] [smallint] NOT NULL,
	[communityName] [varchar](50) NOT NULL,
	[regionId] [tinyint] NOT NULL,
	[guideIndex] [varchar](10) NULL,
	[guideSortOrder] [smallint] NULL,
	[interfaceName] [varchar](50) NULL,
	[subRegionId] [smallint] NULL,
	[countyId] [tinyint] NULL,
 CONSTRAINT [PK_refCommunity] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Attribute]    Script Date: 08/16/2013 11:33:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attribute]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Attribute](
	[id] [smallint] NOT NULL,
	[attributeName] [varchar](100) NOT NULL,
	[attributeGroupId] [smallint] NOT NULL,
 CONSTRAINT [PK_Attribute] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_Attribute] UNIQUE NONCLUSTERED 
(
	[id] ASC,
	[attributeGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Address]    Script Date: 08/16/2013 11:33:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Address](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[addressTypeId] [tinyint] NOT NULL,
	[line1] [varchar](200) NULL,
	[line2] [varchar](200) NULL,
	[line3] [varchar](200) NULL,
	[city] [varchar](200) NULL,
	[provinceStateId] [char](2) NULL,
	[otherRegion] [varchar](200) NULL,
	[countryId] [varchar](2) NULL,
	[postalCode] [varchar](50) NULL,
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AttributeGroupProductType]    Script Date: 08/16/2013 11:33:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AttributeGroupProductType](
	[attributeGroupId] [smallint] NOT NULL,
	[productTypeId] [tinyint] NOT NULL,
 CONSTRAINT [PK_AttributeGroupProductType] PRIMARY KEY CLUSTERED 
(
	[attributeGroupId] ASC,
	[productTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 08/16/2013 11:33:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contact]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Contact](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[contactTypeId] [tinyint] NULL,
	[firstName] [nvarchar](100) NULL,
	[lastName] [nvarchar](100) NULL,
	[jobTitle] [nvarchar](100) NULL,
	[email] [nvarchar](100) NULL,
	[comment] [nvarchar](1000) NULL,
	[businessId] [int] NOT NULL,
	[fileMakerId] [varchar](10) NULL,
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Contact_isDeleted]  DEFAULT ((0)),
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
	[isPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserProfileRole]    Script Date: 08/16/2013 11:35:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserProfileRole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserProfileRole](
	[profileId] [int] NOT NULL,
	[roleId] [int] NOT NULL,
 CONSTRAINT [PK_UserProfileRole] PRIMARY KEY CLUSTERED 
(
	[profileId] ASC,
	[roleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Phone]    Script Date: 08/16/2013 11:33:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Phone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Phone](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[phoneNumber] [varchar](50) NULL,
	[phoneTypeId] [tinyint] NULL,
	[comment] [nvarchar](1000) NULL,
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Phone] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BusinessNote]    Script Date: 08/16/2013 11:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BusinessNote]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BusinessNote](
	[businessId] [int] NOT NULL,
	[noteId] [int] NOT NULL,
 CONSTRAINT [PK_BusinessNote] PRIMARY KEY CLUSTERED 
(
	[businessId] ASC,
	[noteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ContactPhone]    Script Date: 08/16/2013 11:33:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactPhone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactPhone](
	[contactId] [int] NOT NULL,
	[phoneId] [int] NOT NULL,
 CONSTRAINT [PK_ContactPhone] PRIMARY KEY CLUSTERED 
(
	[contactId] ASC,
	[phoneId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ContactNote]    Script Date: 08/16/2013 11:33:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactNote]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactNote](
	[contactId] [int] NOT NULL,
	[noteId] [int] NOT NULL,
 CONSTRAINT [PK_ContactNote] PRIMARY KEY CLUSTERED 
(
	[contactId] ASC,
	[noteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ContactAddress]    Script Date: 08/16/2013 11:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactAddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactAddress](
	[contactId] [int] NOT NULL,
	[addressId] [int] NOT NULL,
 CONSTRAINT [PK_ContactAddress_1] PRIMARY KEY CLUSTERED 
(
	[contactId] ASC,
	[addressId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[BusinessAddress]    Script Date: 08/16/2013 11:33:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BusinessAddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BusinessAddress](
	[businessId] [int] NOT NULL,
	[addressId] [int] NOT NULL,
 CONSTRAINT [PK_BusinessAddress_1] PRIMARY KEY CLUSTERED 
(
	[businessId] ASC,
	[addressId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Product]    Script Date: 08/16/2013 11:33:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Product](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[productTypeId] [tinyint] NOT NULL,
	[productName] [nvarchar](500) NULL,
	[line1] [nvarchar](200) NULL,
	[line2] [nvarchar](200) NULL,
	[line3] [nvarchar](200) NULL,
	[city] [nvarchar](50) NULL,
	[postalCode] [varchar](10) NULL,
	[communityId] [smallint] NULL,
	[subRegionId] [smallint] NULL,
	[latitude] [numeric](9, 6) NULL,
	[longitude] [numeric](9, 6) NULL,
	[proprietor] [nvarchar](300) NULL,
	[email] [nvarchar](300) NULL,
	[web] [nvarchar](300) NULL,
	[telephone] [varchar](100) NULL,
	[secondaryPhone] [varchar](100) NULL,
	[offSeasonPhone] [varchar](100) NULL,
	[fax] [varchar](100) NULL,
	[tollfree] [varchar](100) NULL,
	[tollfreeAreaId] [tinyint] NULL,
	[reservationsOnly] [bit] NOT NULL,
	[isCheckinMember] [bit] NOT NULL CONSTRAINT [DF_Product_isCheckinMember]  DEFAULT ((0)),
	[checkInId] [varchar](10) NULL,
	[accessCanadaRating] [tinyint] NULL,
	[lowRate] [numeric](10, 2) NULL,
	[highRate] [numeric](10, 2) NULL,
	[extraPersonRate] [numeric](10, 2) NULL,
	[periodOfOperationTypeId] [tinyint] NOT NULL CONSTRAINT [DF_Product_periodOfOperationTypeId]  DEFAULT ((1)),
	[rateTypeId] [tinyint] NULL,
	[ratePeriodId] [tinyint] NULL,
	[primaryGuideSectionId] [tinyint] NULL,
	[openMonth] [tinyint] NULL,
	[openDay] [tinyint] NULL,
	[closeMonth] [tinyint] NULL,
	[closeDay] [tinyint] NULL,
	[hasOffSeasonRates] [bit] NOT NULL CONSTRAINT [DF_Product_isOpenAllYear]  DEFAULT ((0)),
	[hasOffSeasonDates] [bit] NOT NULL CONSTRAINT [DF_Product_hasOffSeasonDates]  DEFAULT ((0)),
	[noTax] [bit] NOT NULL CONSTRAINT [DF_Product_noTax]  DEFAULT ((0)),
	[cancellationPolicyId] [tinyint] NULL,
	[fileMakerId] [varchar](10) NULL,
	[parkingSpaces] [smallint] NULL,
	[seatingCapacityInterior] [smallint] NULL,
	[seatingCapacityExterior] [smallint] NULL,
	[otherMemberships] [nvarchar](500) NULL,
	[licenseNumber] [varchar](50) NULL,
	[checkboxLabel] [varchar](50) NULL,
	[paymentReceived] [bit] NOT NULL CONSTRAINT [DF_Product_paymentReceived]  DEFAULT ((0)),
	[paymentAmount] [numeric](10, 2) NULL,
	[attendance] [int] NULL,
	[confirmationDueDate] [datetime] NULL,
	[ownershipTypeId] [tinyint] NULL,
	[sustainabilityTypeId] [tinyint] NULL,
	[capacityTypeId] [tinyint] NULL,
	[isTicketed] [bit] NOT NULL CONSTRAINT [DF_Product_isTicketed]  DEFAULT ((0)),
	[isValid] [bit] NOT NULL CONSTRAINT [DF_Product_isValid]  DEFAULT ((0)),
	[isComplete] [bit] NOT NULL CONSTRAINT [DF_Product_isComplete]  DEFAULT ((0)),
	[isActive] [bit] NOT NULL CONSTRAINT [DF_Product_isActive]  DEFAULT ((0)),
	[overrideErrors] [bit] NOT NULL CONSTRAINT [DF_Product_overrideErrors]  DEFAULT ((0)),
	[isDeleted] [bit] NOT NULL CONSTRAINT [DF_Product_isDeleted]  DEFAULT ((0)),
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
	[confirmationLastReceived] [datetime] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_Product] UNIQUE NONCLUSTERED 
(
	[id] ASC,
	[productTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PrintVersionTranslation]    Script Date: 08/16/2013 11:33:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrintVersionTranslation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PrintVersionTranslation](
	[productId] [int] NOT NULL,
	[languageId] [char](2) NOT NULL,
	[rateDescription] [nvarchar](4000) NULL,
	[dateDescription] [nvarchar](4000) NULL,
	[printDescription] [nvarchar](4000) NULL,
	[unitDescription] [nvarchar](4000) NULL,
	[directions] [nvarchar](4000) NULL,
 CONSTRAINT [PK_PrintVersionTranslation] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[languageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PrintVersion]    Script Date: 08/16/2013 11:33:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PrintVersion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PrintVersion](
	[productId] [int] NOT NULL,
	[periodOfOperationTypeId] [tinyint] NOT NULL CONSTRAINT [DF_PrintVersion_periodOfOperationTypeId]  DEFAULT ((1)),
	[openMonth] [tinyint] NULL,
	[openDay] [tinyint] NULL,
	[closeMonth] [tinyint] NULL,
	[closeDay] [tinyint] NULL,
	[lowRate] [numeric](10, 2) NULL,
	[highRate] [numeric](10, 2) NULL,
	[extraPersonRate] [numeric](10, 2) NULL,
	[rateTypeId] [tinyint] NULL,
	[ratePeriodId] [tinyint] NULL,
	[hasOffSeasonRates] [bit] NOT NULL,
	[hasOffSeasonDates] [bit] NOT NULL CONSTRAINT [DF_PrintVersion_hasOffSeasonDates]  DEFAULT ((0)),
	[cancellationPolicyId] [tinyint] NULL,
	[noTax] [bit] NOT NULL,
 CONSTRAINT [PK_PrintVersion] PRIMARY KEY CLUSTERED 
(
	[productId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[CampgroundOccupancy]    Script Date: 08/16/2013 11:33:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CampgroundOccupancy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CampgroundOccupancy](
	[productId] [int] NOT NULL,
	[reportDate] [datetime] NOT NULL,
	[licenseNumber] [varchar](50) NULL,
	[campgroundTypeId] [tinyint] NULL,
	[starClassRating] [tinyint] NULL,
	[daysOpen] [tinyint] NOT NULL,
	[seasonalAvailable] [smallint] NOT NULL,
	[shortTermAvailable] [smallint] NOT NULL,
	[seasonalSold] [int] NULL,
	[shortTermSold] [int] NULL,
	[totalGuests] [int] NULL,
	[nsTents] [int] NULL,
	[canTents] [int] NULL,
	[usTents] [int] NULL,
	[intTents] [int] NULL,
	[nsRvs] [int] NULL,
	[canRvs] [int] NULL,
	[usRvs] [int] NULL,
	[intRvs] [int] NULL,
	[nsCabins] [int] NULL,
	[canCabins] [int] NULL,
	[usCabins] [int] NULL,
	[intCabins] [int] NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_CampgroundOccupancy] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[reportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AccommodationOccupancy]    Script Date: 08/16/2013 11:33:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccommodationOccupancy]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AccommodationOccupancy](
	[productId] [int] NOT NULL,
	[reportDate] [datetime] NOT NULL,
	[licenseNumber] [varchar](50) NULL,
	[accommodationTypeId] [tinyint] NULL,
	[starClassRating] [tinyint] NULL,
	[daysOpen] [tinyint] NOT NULL,
	[unitsAvailable] [smallint] NOT NULL,
	[totalUnitsSold] [smallint] NULL,
	[totalGuests] [int] NULL,
	[vacationPct] [tinyint] NULL,
	[businessPct] [tinyint] NULL,
	[conventionPct] [tinyint] NULL,
	[motorcoachPct] [tinyint] NULL,
	[otherPct] [tinyint] NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_AccommodationOccupancy] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[reportDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductUnitNumber]    Script Date: 08/16/2013 11:34:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductUnitNumber](
	[productId] [int] NOT NULL,
	[unitTypeId] [tinyint] NOT NULL,
	[units] [int] NOT NULL,
 CONSTRAINT [PK_ProductUnits] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[unitTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ProductTranslation]    Script Date: 08/16/2013 11:34:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductTranslation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductTranslation](
	[productId] [int] NOT NULL,
	[languageId] [char](2) NOT NULL,
	[rateDescription] [nvarchar](4000) NULL,
	[dateDescription] [nvarchar](4000) NULL,
	[webDescription] [nvarchar](max) NULL,
	[keywords] [nvarchar](1000) NULL,
	[directions] [nvarchar](2000) NULL,
	[cancellationPolicy] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ProductTranslation] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[languageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductRegionOfOperation]    Script Date: 08/16/2013 11:34:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductRegionOfOperation](
	[productId] [int] NOT NULL,
	[regionId] [tinyint] NOT NULL,
 CONSTRAINT [PK_ProductRegionOfOperation] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[regionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ProductPaymentType]    Script Date: 08/16/2013 11:34:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductPaymentType](
	[productId] [int] NOT NULL,
	[paymentTypeId] [tinyint] NOT NULL,
 CONSTRAINT [PK_ProductPaymentType] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[paymentTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ProductNote]    Script Date: 08/16/2013 11:34:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductNote]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductNote](
	[productId] [int] NOT NULL,
	[noteId] [int] NOT NULL,
 CONSTRAINT [PK_ProductNote] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[noteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ProductDescription]    Script Date: 08/16/2013 11:34:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductDescription]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductDescription](
	[productId] [int] NOT NULL,
	[languageId] [varchar](2) NOT NULL,
	[descriptionTypeId] [tinyint] NOT NULL,
	[description] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ProductDescription] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[languageId] ASC,
	[descriptionTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductCanadaSelectRating]    Script Date: 08/16/2013 11:34:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductCanadaSelectRating](
	[productId] [int] NOT NULL,
	[canadaSelectRatingTypeId] [tinyint] NOT NULL,
	[ratingValue] [tinyint] NOT NULL,
 CONSTRAINT [PK_ProductCanadaSelectRating] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[canadaSelectRatingTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ProductCaaRating]    Script Date: 08/16/2013 11:34:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductCaaRating](
	[productId] [int] NOT NULL,
	[caaRatingTypeId] [tinyint] NOT NULL,
	[ratingValue] [tinyint] NOT NULL,
 CONSTRAINT [PK_ProductCaaRating] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[caaRatingTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ProductAttribute]    Script Date: 08/16/2013 11:33:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductAttribute]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductAttribute](
	[productId] [int] NOT NULL,
	[productTypeId] [tinyint] NOT NULL,
	[attributeId] [smallint] NOT NULL,
	[attributeGroupId] [smallint] NOT NULL,
 CONSTRAINT [PK_ProductAttribute] PRIMARY KEY CLUSTERED 
(
	[productId] ASC,
	[productTypeId] ASC,
	[attributeId] ASC,
	[attributeGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[OperationPeriod]    Script Date: 08/16/2013 11:33:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OperationPeriod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OperationPeriod](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[productId] [int] NOT NULL,
	[openDate] [datetime] NOT NULL,
	[closeDate] [datetime] NULL,
 CONSTRAINT [PK_OperationPeriod] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Media]    Script Date: 08/16/2013 11:33:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Media]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Media](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[originalFileName] [nvarchar](200) NOT NULL,
	[fileExtension] [varchar](10) NOT NULL,
	[productId] [int] NOT NULL,
	[mediaTypeId] [tinyint] NOT NULL,
	[mediaLanguageId] [tinyint] NULL,
	[sortOrder] [smallint] NULL,
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Media] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactProduct]    Script Date: 08/16/2013 11:33:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ContactProduct]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ContactProduct](
	[contactId] [int] NOT NULL,
	[productId] [int] NOT NULL,
	[contactTypeId] [tinyint] NOT NULL,
 CONSTRAINT [PK_ContactProduct] PRIMARY KEY CLUSTERED 
(
	[contactId] ASC,
	[productId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Url]    Script Date: 08/16/2013 11:35:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Url]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Url](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[url] [varchar](500) NOT NULL,
	[urlTypeId] [tinyint] NOT NULL,
	[productId] [int] NOT NULL,
	[distance] [numeric](6, 1) NULL,
	[lastModifiedBy] [varchar](50) NULL,
	[lastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Url] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TranslationStatus]    Script Date: 08/16/2013 11:35:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TranslationStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TranslationStatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[productId] [int] NOT NULL,
	[fieldId] [tinyint] NOT NULL,
	[secondaryId] [int] NULL,
	[statusDate] [datetime] NOT NULL,
 CONSTRAINT [PK_TranslationStatus] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UrlTranslation]    Script Date: 08/16/2013 11:35:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UrlTranslation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UrlTranslation](
	[urlId] [int] NOT NULL,
	[languageId] [char](2) NOT NULL,
	[title] [nvarchar](500) NOT NULL,
	[description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_UrlTranslation] PRIMARY KEY CLUSTERED 
(
	[urlId] ASC,
	[languageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MediaTranslation]    Script Date: 08/16/2013 11:33:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MediaTranslation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MediaTranslation](
	[mediaId] [int] NOT NULL,
	[languageId] [char](2) NOT NULL,
	[mediaTitle] [nvarchar](100) NULL,
	[caption] [nvarchar](100) NULL,
 CONSTRAINT [PK_MediaTranslation] PRIMARY KEY CLUSTERED 
(
	[mediaId] ASC,
	[languageId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  ForeignKey [FK_AccommodationOccupancy_productId]    Script Date: 08/16/2013 11:33:26 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccommodationOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccommodationOccupancy]'))
ALTER TABLE [dbo].[AccommodationOccupancy]  WITH CHECK ADD  CONSTRAINT [FK_AccommodationOccupancy_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AccommodationOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AccommodationOccupancy]'))
ALTER TABLE [dbo].[AccommodationOccupancy] CHECK CONSTRAINT [FK_AccommodationOccupancy_productId]
GO
/****** Object:  ForeignKey [FK_Address_addressTypeId]    Script Date: 08/16/2013 11:33:27 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_addressTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_addressTypeId] FOREIGN KEY([addressTypeId])
REFERENCES [dbo].[refAddressType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_addressTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_addressTypeId]
GO
/****** Object:  ForeignKey [FK_Address_provinceStateId]    Script Date: 08/16/2013 11:33:27 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_provinceStateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_provinceStateId] FOREIGN KEY([provinceStateId])
REFERENCES [dbo].[refProvinceState] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Address_provinceStateId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Address]'))
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_provinceStateId]
GO
/****** Object:  ForeignKey [FK_Attribute_attributeGroupId]    Script Date: 08/16/2013 11:33:29 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute]'))
ALTER TABLE [dbo].[Attribute]  WITH CHECK ADD  CONSTRAINT [FK_Attribute_attributeGroupId] FOREIGN KEY([attributeGroupId])
REFERENCES [dbo].[AttributeGroup] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Attribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Attribute]'))
ALTER TABLE [dbo].[Attribute] CHECK CONSTRAINT [FK_Attribute_attributeGroupId]
GO
/****** Object:  ForeignKey [FK_AttributeGroupProductType_attributeGroupId]    Script Date: 08/16/2013 11:33:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType]  WITH CHECK ADD  CONSTRAINT [FK_AttributeGroupProductType_attributeGroupId] FOREIGN KEY([attributeGroupId])
REFERENCES [dbo].[AttributeGroup] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType] CHECK CONSTRAINT [FK_AttributeGroupProductType_attributeGroupId]
GO
/****** Object:  ForeignKey [FK_AttributeGroupProductType_productTypeId]    Script Date: 08/16/2013 11:33:32 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType]  WITH CHECK ADD  CONSTRAINT [FK_AttributeGroupProductType_productTypeId] FOREIGN KEY([productTypeId])
REFERENCES [dbo].[refProductType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AttributeGroupProductType_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[AttributeGroupProductType]'))
ALTER TABLE [dbo].[AttributeGroupProductType] CHECK CONSTRAINT [FK_AttributeGroupProductType_productTypeId]
GO
/****** Object:  ForeignKey [FK_BusinessAddress_addressId]    Script Date: 08/16/2013 11:33:35 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress]  WITH CHECK ADD  CONSTRAINT [FK_BusinessAddress_addressId] FOREIGN KEY([addressId])
REFERENCES [dbo].[Address] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress] CHECK CONSTRAINT [FK_BusinessAddress_addressId]
GO
/****** Object:  ForeignKey [FK_BusinessAddress_businessId]    Script Date: 08/16/2013 11:33:35 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress]  WITH CHECK ADD  CONSTRAINT [FK_BusinessAddress_businessId] FOREIGN KEY([businessId])
REFERENCES [dbo].[Business] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessAddress_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessAddress]'))
ALTER TABLE [dbo].[BusinessAddress] CHECK CONSTRAINT [FK_BusinessAddress_businessId]
GO
/****** Object:  ForeignKey [FK_BusinessNote_businessId]    Script Date: 08/16/2013 11:33:36 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote]  WITH CHECK ADD  CONSTRAINT [FK_BusinessNote_businessId] FOREIGN KEY([businessId])
REFERENCES [dbo].[Business] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote] CHECK CONSTRAINT [FK_BusinessNote_businessId]
GO
/****** Object:  ForeignKey [FK_BusinessNote_noteId]    Script Date: 08/16/2013 11:33:36 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote]  WITH CHECK ADD  CONSTRAINT [FK_BusinessNote_noteId] FOREIGN KEY([noteId])
REFERENCES [dbo].[Note] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_BusinessNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[BusinessNote]'))
ALTER TABLE [dbo].[BusinessNote] CHECK CONSTRAINT [FK_BusinessNote_noteId]
GO
/****** Object:  ForeignKey [FK_CampgroundOccupancy_productId]    Script Date: 08/16/2013 11:33:38 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampgroundOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampgroundOccupancy]'))
ALTER TABLE [dbo].[CampgroundOccupancy]  WITH CHECK ADD  CONSTRAINT [FK_CampgroundOccupancy_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CampgroundOccupancy_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[CampgroundOccupancy]'))
ALTER TABLE [dbo].[CampgroundOccupancy] CHECK CONSTRAINT [FK_CampgroundOccupancy_productId]
GO
/****** Object:  ForeignKey [FK_Contact_businessId]    Script Date: 08/16/2013 11:33:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_businessId] FOREIGN KEY([businessId])
REFERENCES [dbo].[Business] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_businessId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [FK_Contact_businessId]
GO
/****** Object:  ForeignKey [FK_Contact_contactTypeId]    Script Date: 08/16/2013 11:33:39 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact]  WITH CHECK ADD  CONSTRAINT [FK_Contact_contactTypeId] FOREIGN KEY([contactTypeId])
REFERENCES [dbo].[refContactType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Contact_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Contact]'))
ALTER TABLE [dbo].[Contact] CHECK CONSTRAINT [FK_Contact_contactTypeId]
GO
/****** Object:  ForeignKey [FK_ContactAddress_addressId]    Script Date: 08/16/2013 11:33:40 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress]  WITH CHECK ADD  CONSTRAINT [FK_ContactAddress_addressId] FOREIGN KEY([addressId])
REFERENCES [dbo].[Address] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_addressId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress] CHECK CONSTRAINT [FK_ContactAddress_addressId]
GO
/****** Object:  ForeignKey [FK_ContactAddress_contactId]    Script Date: 08/16/2013 11:33:40 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress]  WITH CHECK ADD  CONSTRAINT [FK_ContactAddress_contactId] FOREIGN KEY([contactId])
REFERENCES [dbo].[Contact] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactAddress_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactAddress]'))
ALTER TABLE [dbo].[ContactAddress] CHECK CONSTRAINT [FK_ContactAddress_contactId]
GO
/****** Object:  ForeignKey [FK_ContactNote_contactId]    Script Date: 08/16/2013 11:33:42 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote]  WITH CHECK ADD  CONSTRAINT [FK_ContactNote_contactId] FOREIGN KEY([contactId])
REFERENCES [dbo].[Contact] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote] CHECK CONSTRAINT [FK_ContactNote_contactId]
GO
/****** Object:  ForeignKey [FK_ContactNote_noteId]    Script Date: 08/16/2013 11:33:42 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote]  WITH CHECK ADD  CONSTRAINT [FK_ContactNote_noteId] FOREIGN KEY([noteId])
REFERENCES [dbo].[Note] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactNote]'))
ALTER TABLE [dbo].[ContactNote] CHECK CONSTRAINT [FK_ContactNote_noteId]
GO
/****** Object:  ForeignKey [FK_ContactPhone_contactId]    Script Date: 08/16/2013 11:33:44 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone]  WITH CHECK ADD  CONSTRAINT [FK_ContactPhone_contactId] FOREIGN KEY([contactId])
REFERENCES [dbo].[Contact] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone] CHECK CONSTRAINT [FK_ContactPhone_contactId]
GO
/****** Object:  ForeignKey [FK_ContactPhone_phoneId]    Script Date: 08/16/2013 11:33:44 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_phoneId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone]  WITH CHECK ADD  CONSTRAINT [FK_ContactPhone_phoneId] FOREIGN KEY([phoneId])
REFERENCES [dbo].[Phone] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactPhone_phoneId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactPhone]'))
ALTER TABLE [dbo].[ContactPhone] CHECK CONSTRAINT [FK_ContactPhone_phoneId]
GO
/****** Object:  ForeignKey [FK_ContactProduct_contactId]    Script Date: 08/16/2013 11:33:45 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct]  WITH CHECK ADD  CONSTRAINT [FK_ContactProduct_contactId] FOREIGN KEY([contactId])
REFERENCES [dbo].[Contact] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] CHECK CONSTRAINT [FK_ContactProduct_contactId]
GO
/****** Object:  ForeignKey [FK_ContactProduct_contactTypeId]    Script Date: 08/16/2013 11:33:45 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct]  WITH CHECK ADD  CONSTRAINT [FK_ContactProduct_contactTypeId] FOREIGN KEY([contactTypeId])
REFERENCES [dbo].[refContactType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_contactTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] CHECK CONSTRAINT [FK_ContactProduct_contactTypeId]
GO
/****** Object:  ForeignKey [FK_ContactProduct_productId]    Script Date: 08/16/2013 11:33:45 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct]  WITH CHECK ADD  CONSTRAINT [FK_ContactProduct_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContactProduct_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ContactProduct]'))
ALTER TABLE [dbo].[ContactProduct] CHECK CONSTRAINT [FK_ContactProduct_productId]
GO
/****** Object:  ForeignKey [FK_Media_mediaLanguageId]    Script Date: 08/16/2013 11:33:46 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaLanguageId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media]  WITH CHECK ADD  CONSTRAINT [FK_Media_mediaLanguageId] FOREIGN KEY([mediaLanguageId])
REFERENCES [dbo].[refMediaLanguage] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaLanguageId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] CHECK CONSTRAINT [FK_Media_mediaLanguageId]
GO
/****** Object:  ForeignKey [FK_Media_mediaTypeId]    Script Date: 08/16/2013 11:33:46 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media]  WITH CHECK ADD  CONSTRAINT [FK_Media_mediaTypeId] FOREIGN KEY([mediaTypeId])
REFERENCES [dbo].[refMediaType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_mediaTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] CHECK CONSTRAINT [FK_Media_mediaTypeId]
GO
/****** Object:  ForeignKey [FK_Media_productId]    Script Date: 08/16/2013 11:33:46 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media]  WITH CHECK ADD  CONSTRAINT [FK_Media_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Media_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Media]'))
ALTER TABLE [dbo].[Media] CHECK CONSTRAINT [FK_Media_productId]
GO
/****** Object:  ForeignKey [FK_MediaTranslation_mediaId]    Script Date: 08/16/2013 11:33:48 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MediaTranslation_mediaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[MediaTranslation]'))
ALTER TABLE [dbo].[MediaTranslation]  WITH CHECK ADD  CONSTRAINT [FK_MediaTranslation_mediaId] FOREIGN KEY([mediaId])
REFERENCES [dbo].[Media] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MediaTranslation_mediaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[MediaTranslation]'))
ALTER TABLE [dbo].[MediaTranslation] CHECK CONSTRAINT [FK_MediaTranslation_mediaId]
GO
/****** Object:  ForeignKey [FK_OperationPeriod_productId]    Script Date: 08/16/2013 11:33:51 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OperationPeriod_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[OperationPeriod]'))
ALTER TABLE [dbo].[OperationPeriod]  WITH CHECK ADD  CONSTRAINT [FK_OperationPeriod_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_OperationPeriod_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[OperationPeriod]'))
ALTER TABLE [dbo].[OperationPeriod] CHECK CONSTRAINT [FK_OperationPeriod_productId]
GO
/****** Object:  ForeignKey [FK_Phone_phoneTypeId]    Script Date: 08/16/2013 11:33:52 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Phone_phoneTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Phone]'))
ALTER TABLE [dbo].[Phone]  WITH CHECK ADD  CONSTRAINT [FK_Phone_phoneTypeId] FOREIGN KEY([phoneTypeId])
REFERENCES [dbo].[refPhoneType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Phone_phoneTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Phone]'))
ALTER TABLE [dbo].[Phone] CHECK CONSTRAINT [FK_Phone_phoneTypeId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_cancellationPolicyId]    Script Date: 08/16/2013 11:33:54 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion]  WITH CHECK ADD  CONSTRAINT [FK_PrintVersion_cancellationPolicyId] FOREIGN KEY([cancellationPolicyId])
REFERENCES [dbo].[refCancellationPolicy] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] CHECK CONSTRAINT [FK_PrintVersion_cancellationPolicyId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_periodOfOperationTypeId]    Script Date: 08/16/2013 11:33:54 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion]  WITH CHECK ADD  CONSTRAINT [FK_PrintVersion_periodOfOperationTypeId] FOREIGN KEY([periodOfOperationTypeId])
REFERENCES [dbo].[refPeriodOfOperationType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] CHECK CONSTRAINT [FK_PrintVersion_periodOfOperationTypeId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_productId]    Script Date: 08/16/2013 11:33:54 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion]  WITH CHECK ADD  CONSTRAINT [FK_PrintVersion_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] CHECK CONSTRAINT [FK_PrintVersion_productId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_ratePeriodId]    Script Date: 08/16/2013 11:33:54 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion]  WITH CHECK ADD  CONSTRAINT [FK_PrintVersion_ratePeriodId] FOREIGN KEY([ratePeriodId])
REFERENCES [dbo].[refRatePeriod] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] CHECK CONSTRAINT [FK_PrintVersion_ratePeriodId]
GO
/****** Object:  ForeignKey [FK_PrintVersion_rateTypeId]    Script Date: 08/16/2013 11:33:54 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion]  WITH CHECK ADD  CONSTRAINT [FK_PrintVersion_rateTypeId] FOREIGN KEY([rateTypeId])
REFERENCES [dbo].[refRateType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersion_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersion]'))
ALTER TABLE [dbo].[PrintVersion] CHECK CONSTRAINT [FK_PrintVersion_rateTypeId]
GO
/****** Object:  ForeignKey [FK_PrintVersionTranslation_productId]    Script Date: 08/16/2013 11:33:55 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersionTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersionTranslation]'))
ALTER TABLE [dbo].[PrintVersionTranslation]  WITH CHECK ADD  CONSTRAINT [FK_PrintVersionTranslation_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PrintVersionTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[PrintVersionTranslation]'))
ALTER TABLE [dbo].[PrintVersionTranslation] CHECK CONSTRAINT [FK_PrintVersionTranslation_productId]
GO
/****** Object:  ForeignKey [FK_Product_cancellationPolicyId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_cancellationPolicyId] FOREIGN KEY([cancellationPolicyId])
REFERENCES [dbo].[refCancellationPolicy] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_cancellationPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_cancellationPolicyId]
GO
/****** Object:  ForeignKey [FK_Product_capacityTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_capacityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_capacityTypeId] FOREIGN KEY([capacityTypeId])
REFERENCES [dbo].[refCapacityType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_capacityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_capacityTypeId]
GO
/****** Object:  ForeignKey [FK_Product_communityId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_communityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_communityId] FOREIGN KEY([communityId])
REFERENCES [dbo].[refCommunity] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_communityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_communityId]
GO
/****** Object:  ForeignKey [FK_Product_ownershipTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ownershipTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ownershipTypeId] FOREIGN KEY([ownershipTypeId])
REFERENCES [dbo].[refOwnershipType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ownershipTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ownershipTypeId]
GO
/****** Object:  ForeignKey [FK_Product_periodOfOperationTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_periodOfOperationTypeId] FOREIGN KEY([periodOfOperationTypeId])
REFERENCES [dbo].[refPeriodOfOperationType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_periodOfOperationTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_periodOfOperationTypeId]
GO
/****** Object:  ForeignKey [FK_Product_primaryGuideSectionId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_primaryGuideSectionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_primaryGuideSectionId] FOREIGN KEY([primaryGuideSectionId])
REFERENCES [dbo].[refGuideSection] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_primaryGuideSectionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_primaryGuideSectionId]
GO
/****** Object:  ForeignKey [FK_Product_productTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_productTypeId] FOREIGN KEY([productTypeId])
REFERENCES [dbo].[refProductType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_productTypeId]
GO
/****** Object:  ForeignKey [FK_Product_ratePeriodId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ratePeriodId] FOREIGN KEY([ratePeriodId])
REFERENCES [dbo].[refRatePeriod] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_ratePeriodId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ratePeriodId]
GO
/****** Object:  ForeignKey [FK_Product_rateTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_rateTypeId] FOREIGN KEY([rateTypeId])
REFERENCES [dbo].[refRateType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_rateTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_rateTypeId]
GO
/****** Object:  ForeignKey [FK_Product_subRegionId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_subRegionId] FOREIGN KEY([subRegionId])
REFERENCES [dbo].[refSubRegion] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_subRegionId]
GO
/****** Object:  ForeignKey [FK_Product_sustainabilityTypeId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_sustainabilityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_sustainabilityTypeId] FOREIGN KEY([sustainabilityTypeId])
REFERENCES [dbo].[refSustainabilityType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_sustainabilityTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_sustainabilityTypeId]
GO
/****** Object:  ForeignKey [FK_Product_tollfreeAreaId]    Script Date: 08/16/2013 11:33:57 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_tollfreeAreaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_tollfreeAreaId] FOREIGN KEY([tollfreeAreaId])
REFERENCES [dbo].[refTollfreeArea] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Product_tollfreeAreaId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_tollfreeAreaId]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_Attribute]    Script Date: 08/16/2013 11:33:58 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Attribute]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttribute_Attribute] FOREIGN KEY([attributeId], [attributeGroupId])
REFERENCES [dbo].[Attribute] ([id], [attributeGroupId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Attribute]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] CHECK CONSTRAINT [FK_ProductAttribute_Attribute]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_attributeGroupId]    Script Date: 08/16/2013 11:33:58 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttribute_attributeGroupId] FOREIGN KEY([attributeGroupId])
REFERENCES [dbo].[AttributeGroup] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_attributeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] CHECK CONSTRAINT [FK_ProductAttribute_attributeGroupId]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_Product]    Script Date: 08/16/2013 11:33:58 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Product]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttribute_Product] FOREIGN KEY([productId], [productTypeId])
REFERENCES [dbo].[Product] ([id], [productTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_Product]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] CHECK CONSTRAINT [FK_ProductAttribute_Product]
GO
/****** Object:  ForeignKey [FK_ProductAttribute_productTypeId]    Script Date: 08/16/2013 11:33:58 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttribute_productTypeId] FOREIGN KEY([productTypeId])
REFERENCES [dbo].[refProductType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductAttribute_productTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductAttribute]'))
ALTER TABLE [dbo].[ProductAttribute] CHECK CONSTRAINT [FK_ProductAttribute_productTypeId]
GO
/****** Object:  ForeignKey [FK_ProductCaaRating_caaRatingTypeId]    Script Date: 08/16/2013 11:34:00 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_caaRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating]  WITH CHECK ADD  CONSTRAINT [FK_ProductCaaRating_caaRatingTypeId] FOREIGN KEY([caaRatingTypeId])
REFERENCES [dbo].[refCaaRatingType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_caaRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating] CHECK CONSTRAINT [FK_ProductCaaRating_caaRatingTypeId]
GO
/****** Object:  ForeignKey [FK_ProductCaaRating_productId]    Script Date: 08/16/2013 11:34:00 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating]  WITH CHECK ADD  CONSTRAINT [FK_ProductCaaRating_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCaaRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCaaRating]'))
ALTER TABLE [dbo].[ProductCaaRating] CHECK CONSTRAINT [FK_ProductCaaRating_productId]
GO
/****** Object:  ForeignKey [FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]    Script Date: 08/16/2013 11:34:01 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating]  WITH CHECK ADD  CONSTRAINT [FK_ProductCanadaSelectRating_canadaSelectRatingTypeId] FOREIGN KEY([canadaSelectRatingTypeId])
REFERENCES [dbo].[refCanadaSelectRatingType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating] CHECK CONSTRAINT [FK_ProductCanadaSelectRating_canadaSelectRatingTypeId]
GO
/****** Object:  ForeignKey [FK_ProductCanadaSelectRating_productId]    Script Date: 08/16/2013 11:34:01 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating]  WITH CHECK ADD  CONSTRAINT [FK_ProductCanadaSelectRating_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCanadaSelectRating_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCanadaSelectRating]'))
ALTER TABLE [dbo].[ProductCanadaSelectRating] CHECK CONSTRAINT [FK_ProductCanadaSelectRating_productId]
GO
/****** Object:  ForeignKey [FK_ProductDescription_ProductDescription]    Script Date: 08/16/2013 11:34:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_ProductDescription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription]  WITH CHECK ADD  CONSTRAINT [FK_ProductDescription_ProductDescription] FOREIGN KEY([productId], [languageId], [descriptionTypeId])
REFERENCES [dbo].[ProductDescription] ([productId], [languageId], [descriptionTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_ProductDescription]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] CHECK CONSTRAINT [FK_ProductDescription_ProductDescription]
GO
/****** Object:  ForeignKey [FK_ProductDescription_productId]    Script Date: 08/16/2013 11:34:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription]  WITH CHECK ADD  CONSTRAINT [FK_ProductDescription_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] CHECK CONSTRAINT [FK_ProductDescription_productId]
GO
/****** Object:  ForeignKey [FK_ProductDescription_productId]    Script Date: 08/16/2013 11:34:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription]  WITH CHECK ADD  CONSTRAINT [FK_ProductDescription_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] CHECK CONSTRAINT [FK_ProductDescription_productId]
GO
/****** Object:  ForeignKey [FK_ProductDescription_descriptionTypeId]    Script Date: 09/25/2013 10:54:21 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_descriptionTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription]  WITH CHECK ADD  CONSTRAINT [FK_ProductDescription_descriptionTypeId] FOREIGN KEY([descriptionTypeId])
REFERENCES [dbo].[refDescriptionType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductDescription_descriptionTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductDescription]'))
ALTER TABLE [dbo].[ProductDescription] CHECK CONSTRAINT [FK_ProductDescription_descriptionTypeId]
GO
/****** Object:  ForeignKey [FK_ProductNote_noteId]    Script Date: 08/16/2013 11:34:04 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote]  WITH CHECK ADD  CONSTRAINT [FK_ProductNote_noteId] FOREIGN KEY([noteId])
REFERENCES [dbo].[Note] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_noteId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote] CHECK CONSTRAINT [FK_ProductNote_noteId]
GO
/****** Object:  ForeignKey [FK_ProductNote_productId]    Script Date: 08/16/2013 11:34:04 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote]  WITH CHECK ADD  CONSTRAINT [FK_ProductNote_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductNote_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductNote]'))
ALTER TABLE [dbo].[ProductNote] CHECK CONSTRAINT [FK_ProductNote_productId]
GO
/****** Object:  ForeignKey [FK_ProductPaymentType_paymentTypeId]    Script Date: 08/16/2013 11:34:06 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_paymentTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType]  WITH CHECK ADD  CONSTRAINT [FK_ProductPaymentType_paymentTypeId] FOREIGN KEY([paymentTypeId])
REFERENCES [dbo].[refPaymentType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_paymentTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType] CHECK CONSTRAINT [FK_ProductPaymentType_paymentTypeId]
GO
/****** Object:  ForeignKey [FK_ProductPaymentType_productId]    Script Date: 08/16/2013 11:34:06 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType]  WITH CHECK ADD  CONSTRAINT [FK_ProductPaymentType_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductPaymentType_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductPaymentType]'))
ALTER TABLE [dbo].[ProductPaymentType] CHECK CONSTRAINT [FK_ProductPaymentType_productId]
GO
/****** Object:  ForeignKey [FK_ProductRegionOfOperation_productId]    Script Date: 08/16/2013 11:34:07 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation]  WITH CHECK ADD  CONSTRAINT [FK_ProductRegionOfOperation_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation] CHECK CONSTRAINT [FK_ProductRegionOfOperation_productId]
GO
/****** Object:  ForeignKey [FK_ProductRegionOfOperation_regionId]    Script Date: 08/16/2013 11:34:07 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation]  WITH CHECK ADD  CONSTRAINT [FK_ProductRegionOfOperation_regionId] FOREIGN KEY([regionId])
REFERENCES [dbo].[refRegion] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductRegionOfOperation_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductRegionOfOperation]'))
ALTER TABLE [dbo].[ProductRegionOfOperation] CHECK CONSTRAINT [FK_ProductRegionOfOperation_regionId]
GO
/****** Object:  ForeignKey [FK_ProductTranslation_productId]    Script Date: 08/16/2013 11:34:09 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductTranslation]'))
ALTER TABLE [dbo].[ProductTranslation]  WITH CHECK ADD  CONSTRAINT [FK_ProductTranslation_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductTranslation_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductTranslation]'))
ALTER TABLE [dbo].[ProductTranslation] CHECK CONSTRAINT [FK_ProductTranslation_productId]
GO
/****** Object:  ForeignKey [FK_ProductUnitNumber_productId]    Script Date: 08/16/2013 11:34:10 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber]  WITH CHECK ADD  CONSTRAINT [FK_ProductUnitNumber_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber] CHECK CONSTRAINT [FK_ProductUnitNumber_productId]
GO
/****** Object:  ForeignKey [FK_ProductUnitNumber_unitTypeId]    Script Date: 08/16/2013 11:34:10 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_unitTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber]  WITH CHECK ADD  CONSTRAINT [FK_ProductUnitNumber_unitTypeId] FOREIGN KEY([unitTypeId])
REFERENCES [dbo].[refUnitType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductUnitNumber_unitTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductUnitNumber]'))
ALTER TABLE [dbo].[ProductUnitNumber] CHECK CONSTRAINT [FK_ProductUnitNumber_unitTypeId]
GO
/****** Object:  ForeignKey [FK_refCommunity_countyId]    Script Date: 08/16/2013 11:34:23 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_countyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity]  WITH CHECK ADD  CONSTRAINT [FK_refCommunity_countyId] FOREIGN KEY([countyId])
REFERENCES [dbo].[refCounty] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_countyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] CHECK CONSTRAINT [FK_refCommunity_countyId]
GO
/****** Object:  ForeignKey [FK_refCommunity_regionId]    Script Date: 08/16/2013 11:34:23 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity]  WITH CHECK ADD  CONSTRAINT [FK_refCommunity_regionId] FOREIGN KEY([regionId])
REFERENCES [dbo].[refRegion] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_regionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] CHECK CONSTRAINT [FK_refCommunity_regionId]
GO
/****** Object:  ForeignKey [FK_refCommunity_subRegionId]    Script Date: 08/16/2013 11:34:23 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity]  WITH CHECK ADD  CONSTRAINT [FK_refCommunity_subRegionId] FOREIGN KEY([subRegionId])
REFERENCES [dbo].[refSubRegion] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_refCommunity_subRegionId]') AND parent_object_id = OBJECT_ID(N'[dbo].[refCommunity]'))
ALTER TABLE [dbo].[refCommunity] CHECK CONSTRAINT [FK_refCommunity_subRegionId]
GO
/****** Object:  ForeignKey [FK_TranslationStatus_fieldId]    Script Date: 08/16/2013 11:35:01 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_fieldId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus]  WITH CHECK ADD  CONSTRAINT [FK_TranslationStatus_fieldId] FOREIGN KEY([fieldId])
REFERENCES [dbo].[refProductField] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_fieldId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus] CHECK CONSTRAINT [FK_TranslationStatus_fieldId]
GO
/****** Object:  ForeignKey [FK_TranslationStatus_productId]    Script Date: 08/16/2013 11:35:01 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus]  WITH CHECK ADD  CONSTRAINT [FK_TranslationStatus_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TranslationStatus_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[TranslationStatus]'))
ALTER TABLE [dbo].[TranslationStatus] CHECK CONSTRAINT [FK_TranslationStatus_productId]
GO
/****** Object:  ForeignKey [FK_Url_productId]    Script Date: 08/16/2013 11:35:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url]  WITH CHECK ADD  CONSTRAINT [FK_Url_productId] FOREIGN KEY([productId])
REFERENCES [dbo].[Product] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_productId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url] CHECK CONSTRAINT [FK_Url_productId]
GO
/****** Object:  ForeignKey [FK_Url_urlTypeId]    Script Date: 08/16/2013 11:35:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_urlTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url]  WITH CHECK ADD  CONSTRAINT [FK_Url_urlTypeId] FOREIGN KEY([urlTypeId])
REFERENCES [dbo].[refUrlType] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Url_urlTypeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Url]'))
ALTER TABLE [dbo].[Url] CHECK CONSTRAINT [FK_Url_urlTypeId]
GO
/****** Object:  ForeignKey [FK_UrlTranslation_urlId]    Script Date: 08/16/2013 11:35:04 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UrlTranslation_urlId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UrlTranslation]'))
ALTER TABLE [dbo].[UrlTranslation]  WITH CHECK ADD  CONSTRAINT [FK_UrlTranslation_urlId] FOREIGN KEY([urlId])
REFERENCES [dbo].[Url] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UrlTranslation_urlId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UrlTranslation]'))
ALTER TABLE [dbo].[UrlTranslation] CHECK CONSTRAINT [FK_UrlTranslation_urlId]
GO
/****** Object:  ForeignKey [FK_UserProfileRole_profileId]    Script Date: 08/16/2013 11:35:07 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_profileId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole]  WITH CHECK ADD  CONSTRAINT [FK_UserProfileRole_profileId] FOREIGN KEY([profileId])
REFERENCES [dbo].[UserProfile] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_profileId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole] CHECK CONSTRAINT [FK_UserProfileRole_profileId]
GO
/****** Object:  ForeignKey [FK_UserProfileRole_roleId]    Script Date: 08/16/2013 11:35:07 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_roleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole]  WITH CHECK ADD  CONSTRAINT [FK_UserProfileRole_roleId] FOREIGN KEY([roleId])
REFERENCES [dbo].[UserRole] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserProfileRole_roleId]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserProfileRole]'))
ALTER TABLE [dbo].[UserProfileRole] CHECK CONSTRAINT [FK_UserProfileRole_roleId]
GO
