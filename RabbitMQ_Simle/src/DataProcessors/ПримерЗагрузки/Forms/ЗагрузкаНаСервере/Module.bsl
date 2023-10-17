  
  #Область Взаимодействие 

&НаКлиенте
Процедура ПроверитьПодключение(Команда)
	ПроверитьПодключениеНаСервере();
КонецПроцедуры
&НаСервере
Процедура ПроверитьПодключениеНаСервере()
	Настройки = RebbitMQСервер.ПолучитьНастройкиПодключенияИзРегистра();
	
	Компонента = RebbitMQСервер.ПолучитьКомпоненту();  
	
	RebbitMQКлиентСервер.ПроверитьПодключение(Компонента, Настройки);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСообщение(Команда)
	ОтправитьСообщениеНаСервере();
КонецПроцедуры
&НаСервере
Процедура ОтправитьСообщениеНаСервере()
	Настройки = RebbitMQСервер.ПолучитьНастройкиПодключенияИзРегистра();
	
	Компонента = RebbitMQСервер.ПолучитьКомпоненту();
	
	ТекстJSON = RebbitMQКлиентСервер.СериализоватьВJSON(Сообщение);	
	
	RebbitMQКлиентСервер.ОтправитьСообщение(Компонента, Настройки, ТекстJSON);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСообщение(Команда)
	ПолучитьСообщениеНаСервере();
КонецПроцедуры
&НаСервере
Процедура ПолучитьСообщениеНаСервере()
	Настройки = RebbitMQСервер.ПолучитьНастройкиПодключенияИзРегистра();
	
	Компонента = RebbitMQСервер.ПолучитьКомпоненту();
	
	Ответ = RebbitMQКлиентСервер.ПрочитатьСообщение(Компонента, Настройки);
КонецПроцедуры

#КонецОбласти
