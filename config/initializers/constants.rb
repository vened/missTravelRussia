REGISTRATION_END_DATE = "2018-08-07".to_date # последний день регистрации
REGISTRATION_COUNTDOWN = (REGISTRATION_END_DATE - Date.current).to_i # кол-во дней до конца регистрации
REGISTRATION_AVIALABLE = REGISTRATION_COUNTDOWN > 0 # флаг доступности регистрации

