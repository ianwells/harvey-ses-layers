import glob
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
"""
Data from:
http://pdata.hcad.org/download/index.html
Land use codes reference:
http://hcad.org/hcad-resources/hcad-appraisal-codes/hcad-land-use-codes/
"""

real_acct_df_colnames = ["ACCOUNT", "TAX_YEAR", "MAILTO", "MAIL_ADDR_1",
                         "MAIL_ADDR_2", "MAIL_CITY", "MAIL_STATE", "MAIL_ZIP",
                         "MAIL_COUNTRY", "UNDELIVERABLE", "STR_PFX", "STR_NUM",
                         "STR_NUM_SFX", "STR_NAME", "STR_SFX", "STR_SFX_DIR",
                         "STR_UNIT", "SITE_ADDR_1", "SITE_ADDR_2",
                         "SITE_ADDR_3", "STATE_CLASS", "SCHOOL_DIST",
                         "MAP_FACET", "KEY_MAP", "NEIGHBRHOOD_CODE",
                         "NEIGHBORHOOD_GROUP", "MARKET_AREA_1",
                         "MARKET_AREA_1_DSCR", "MARKET_AREA_2", 
                         "MARKET_AREA_2_DSCR", "ECON_AREA", "ECON_BLD_CLASS", 
                         "CENTER_CODE", "YR_IMPR", "TR_ANNEXED", "SPLT_DT",
                         "DSC_CD", "NXT_BUILDING", "TOTAL_BUILDING_AREA",
                         "TOTAL_LAND_AREA", "ACERAGE", "CAP_ACCOUNT", 
                         "SHARED_CAD_CODE", "LAND_VALUE", "IMPROVEMENT_VALUE", 
                         "EXTRA_FEATURES_VALUE", "AG_VALUE", "ASSESSED_VALUE",
                         "TOTAL_APPRAISED_VALUE", "TOTAL_MARKET_VALUE", 
                         "PRIOR_LND_VALUE", "PRIOR_IMPR_VALUE", 
                         "PRIOR_X_FEATURES_VALUE", "PRIOR_AG_VALUE",
                         "PRIOR_TOTAL_APPRAISED_VALUE", 
                         "PRIOR_TOTAL_MARKET_VALUE", "NEW_CONSTRUCTION_VALUE",
                         "TOTAL_RCN_VALUE", "VALUE_STATUS", "NOTICED", 
                         "NOTICE_DATE", "PROTESTED", "CERTIFIED_DATE",
                         "LAST_INSPECTED_DATE", "LAST_INSPECTED_BY", 
                         "NEW_OWNER_DATE", "LEGAL_DSCR_1", "LEGAL_DSCR_2",
                         "LEGAL_DSCR_3","LEGAL_DSCR_4", "JURS"]
                         
land_df_colnames = ["ACCOUNT", "LINE_NUMBER", "LAND_USE_CODE",
                    "LAND_USE_DSCR", "SITE_CD", "SITE_CD_DSCR",
                    "SITE_ADJ", "UNIT_TYPE", "UNITS", "SIZE_FACTOR",
                    "SITE_FACT", "APPR_OVERRIDE_FACTOR",
                    "APPR_OVERRIDE_REASON", "TOT_ADJ", "UNIT_PRICE",
                    "ADJ_UNIT_PRICE", "VALUE", "OVERRIDE_VALUE"]

land_use_codes = {1006: 'condo_land',
                  4201: 'residential_structure_on_apt_land',
                  4108: 'commercial_mobile_home',
                  4209: 'apt_4_to_20',
                  4211: 'apt_garden',
                  4212: 'apt_mid_rise',
                  4213: 'mobile_home_park',
                  4214: 'apt_high_rise',
                  4221: 'subsidized_housing',
                  4301: 'res_struct_or_conv',
                  4222: 'apartment_tax_credit_properties',
                  4299: 'apartment_new_construction'}

real_acct_df = pd.read_csv("../data/real_acct_owner/real_acct.txt", sep='\t',
                            encoding="cp437", names = real_acct_df_colnames)

real_acct_df.drop(["STR_PFX", "STR_NUM", "STR_NUM_SFX", "STR_NAME",
                   "STR_SFX", "STR_SFX_DIR", "STR_UNIT", "SITE_ADDR_1",
                   "SITE_ADDR_2", "SITE_ADDR_3", "STATE_CLASS",
                   "SCHOOL_DIST", "MAP_FACET", "KEY_MAP", "NEIGHBRHOOD_CODE",
                   "NEIGHBORHOOD_GROUP", "MARKET_AREA_1",
                   "MARKET_AREA_1_DSCR", "MARKET_AREA_2", "MARKET_AREA_2_DSCR", 
                   "ECON_AREA", "ECON_BLD_CLASS", "CENTER_CODE", "YR_IMPR",
                   "TR_ANNEXED", "SPLT_DT", "DSC_CD", "NXT_BUILDING",
                   "TOTAL_BUILDING_AREA", "TOTAL_LAND_AREA", "ACERAGE",
                   "CAP_ACCOUNT", "SHARED_CAD_CODE", "LAND_VALUE",
                   "IMPROVEMENT_VALUE", "EXTRA_FEATURES_VALUE", "AG_VALUE", 
                   "PRIOR_LND_VALUE", "PRIOR_IMPR_VALUE",
                   "PRIOR_X_FEATURES_VALUE", "PRIOR_AG_VALUE", 
                   "PRIOR_TOTAL_APPRAISED_VALUE", "PRIOR_TOTAL_MARKET_VALUE", 
                   "NEW_CONSTRUCTION_VALUE", "TOTAL_RCN_VALUE", "VALUE_STATUS",
                   "NOTICED", "NOTICE_DATE", "PROTESTED", "CERTIFIED_DATE", 
                   "LAST_INSPECTED_DATE", "LAST_INSPECTED_BY", "NEW_OWNER_DATE",
                   "LEGAL_DSCR_1", "LEGAL_DSCR_2", "LEGAL_DSCR_3",
                   "LEGAL_DSCR_4", "JURS"], axis=1, inplace=True)
                  
land_df = pd.read_csv("../data/real_building_land/land.txt",sep='\t',
                            encoding="cp437", names = land_df_colnames)
land_df.drop(["LINE_NUMBER", "SITE_CD", "SITE_CD_DSCR",
               "SITE_ADJ", "UNIT_TYPE", "UNITS", "SIZE_FACTOR", "SITE_FACT",
               "APPR_OVERRIDE_FACTOR", "APPR_OVERRIDE_REASON", "TOT_ADJ",
               "UNIT_PRICE", "ADJ_UNIT_PRICE", "VALUE", "OVERRIDE_VALUE"],
               axis=1, inplace=True) 
               
merged_df = real_acct_df.merge(land_df, on="ACCOUNT")

# garbage collection for memory reasons
del land_df
del real_acct_df               

filtered_df = merged_df[merged_df['LAND_USE_CODE'].isin(land_use_codes.keys())]

filtered_df.to_csv("residential_land_use_codes.csv", index=False)
