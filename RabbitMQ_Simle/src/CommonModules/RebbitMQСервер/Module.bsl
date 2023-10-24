#Область Настройки

Функция ПолучитьНастройкиПодключенияИзРегистра() Экспорт  
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КАБНастройкиПодключенияКRebbitMQ.Адрес КАК Адрес,
		|	КАБНастройкиПодключенияКRebbitMQ.Порт КАК Порт,
		|	КАБНастройкиПодключенияКRebbitMQ.Логин КАК Логин,
		|	КАБНастройкиПодключенияКRebbitMQ.Пароль КАК Пароль,
		|	КАБНастройкиПодключенияКRebbitMQ.ВиртуальныйХост КАК ВиртуальныйХост,
		|	КАБНастройкиПодключенияКRebbitMQ.ТочкаОбмена КАК ТочкаОбмена,
		|	КАБНастройкиПодключенияКRebbitMQ.ИмяОчереди КАК ИмяОчереди,
		|	КАБНастройкиПодключенияКRebbitMQ.Включен КАК Включен,
		|	КАБНастройкиПодключенияКRebbitMQ.Таймаут КАК Таймаут,
		|	КАБНастройкиПодключенияКRebbitMQ.КлючМаршрута КАК КлючМаршрута
		|ИЗ
		|	РегистрСведений.КАБНастройкиПодключенияКRebbitMQ КАК КАБНастройкиПодключенияКRebbitMQ
		|ГДЕ
		|	КАБНастройкиПодключенияКRebbitMQ.Включен";
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	

	
	Настройки = Новый Структура("Адрес,Порт,Логин,Пароль,ВиртуальныйХост,ТочкаОбмена,ИмяОчереди,Таймаут,КлючМаршрута");
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Настройки, ВыборкаДетальныеЗаписи);
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

Функция ПолучитьНастройкиПодключения(Адрес, Порт, Логин, Пароль, ВиртуальныйХост,ТочкаОбмена, ИмяОчереди, Таймаут) Экспорт  
	
	Возврат Новый Структура("Адрес,Порт,Логин,Пароль,ВиртуальныйХост,ТочкаОбмена,ИмяОчереди,Таймаут",
			Адрес, Порт, Логин, Пароль, ВиртуальныйХост, ТочкаОбмена, ИмяОчереди, Таймаут);
КонецФункции

#КонецОбласти

#Область Компонента 

Функция ПолучитьКомпоненту() Экспорт 

	КлиентКомпоненты = Неопределено;
	Если Не ИнициализироватьКомпоненту(КлиентКомпоненты) Тогда
		
		РезультатПодключения = ПодключитьВнешнююКомпоненту("ОбщийМакет.PinkRabbitMQ", "BITERP", ТипВнешнейКомпоненты.Native);
		
		Если РезультатПодключения Тогда
			ИнициализироватьКомпоненту(КлиентКомпоненты);
		КонецЕсли;    	
	КонецЕсли;
	
	Возврат КлиентКомпоненты;
	
КонецФункции

Функция ИнициализироватьКомпоненту(Компонента)
	
	Попытка
		Компонента  = Новый("AddIn.BITERP.PinkRabbitMQ");
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

#КонецОбласти

