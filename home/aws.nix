{ pkgs, ... }: {
  
  enable = true;
    
  settings = {
    default = {
      region = "us-west-2";
      output = "json";
    };

    "profile darkstar-beta" = {
      sso_session = "stelo";
      sso_account_id = "226776128672";
      sso_role_name = "admin";
      region = "us-west-2";
      output = "json";
    };

    "profile darkstar-prod" = {
      sso_session = "stelo";
      sso_account_id = "354937814820";
      sso_role_name = "readOnly";
      region = "us-west-2";
      output = "json";
    };

    "profile darkstar-global" = {
      sso_session = "stelo";
      sso_account_id = "616957748271";
      sso_role_name = "powerUser";
      region = "us-east-1";
      output = "json";
    };

    "profile foxbat-prod" = {
      sso_session = "stelo";
      sso_account_id = "637423179787";
      sso_role_name = "admin";
      region = "us-west-2";
      output = "json";
    };

    "profile stelo-dev" = {
      sso_session = "stelo";
      sso_account_id = "354902343412";
      sso_role_name = "admin";
      region = "us-east-1";
      output = "json";
    };

    "sso-session stelo" = {
      sso_region = "us-west-2";
      sso_start_url = "https://stelo.awsapps.com/start/#";
      sso_registration_scopes = "sso:account:access";
    };
  };
} 