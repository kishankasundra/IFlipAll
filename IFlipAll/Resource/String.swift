//
//  String.swift
//  Viin
//
//  Created by kishan on 27/09/20.
//  Copyright © 2020 Stark. All rights reserved.
//

let appString = AppString()

class AppString
{
    let empty_email_msg = "Please enter email"
    let invalid_email_msg = "Please enter valid email"
    let empty_password_msg = "Please enter password"
    let empty_full_name_msg = "Please enter full name"
    let empty_name_msg = "Please enter name"
    let empty_message_msg = "Please enter message"
    
    let empty_new_password_msg = "Please enter new password"
    let empty_old_password_msg = "Please enter old password"
    let empty_confirm_password_msg = "Please enter confirm password"
    let new_password_and_confirm_password_does_not_match = "New password and confirm password does not match"
    let password_and_confirm_password_does_not_match = "Password and confirm password does not match"
    
    let empty_mobile_msg = "Please enter mobile number"
    let invalid_mobile_msg = "Please enter valid mobile number"
    let unselect_gender_msg = "Please select gender"
    let unselect_marital_status_msg = "Please select marital status"
    let unselect_job_msg = "Please select job"
    let empty_city_msg = "Please enter city"
    let empty_country_msg = "Please enter country"
    let empty_zipcode_msg = "Please enter zipcode"
    
    let unselect_terms_msg = "Please select terms and condition"
    let unselect_privacy_msg = "Please select privacy policy"
    
    let empty_kitchen_name_msg = "Please enter kitchen name"
    let empty_chef_name_msg = "Please enter chef name"
    let empty_speciality_msg = "Please enter speciality"
    let empty_bio_msg = "Please enter bio"
    let empty_address_msg = "Please select address"
    
    let empty_product_title_msg = "Please enter product title"
    let empty_price_msg = "Please enter price"
    let empty_product_condition_msg = "Please enter product condition"
    let empty_description_msg = "Please enter description"
    let empty_image_msg = "Please add image"
    let empty_product_category = "Please select category"
        
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
