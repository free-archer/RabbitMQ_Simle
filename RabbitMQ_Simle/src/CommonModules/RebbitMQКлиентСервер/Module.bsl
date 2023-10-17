#Область Взаимодействие  

Процедура ПроверитьПодключение(КлиентКомпоненты, НастройкиПодключения) Экспорт
	
	Попытка
		КлиентКомпоненты.Connect(
				НастройкиПодключения.Адрес,
				НастройкиПодключения.Порт,
				НастройкиПодключения.Логин,
				НастройкиПодключения.Пароль,
				НастройкиПодключения.ВиртуальныйХост);
			Исключение
		СистемнаяОшибка = ОписаниеОшибки();
		ТекстСообщения = "Ошибка подключения!%СистемнаяОшибка%";
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СистемнаяОшибка%", СистемнаяОшибка);
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Сообщить(НСтр("ru = 'Подключение успешно выполнено!'"));
	
КонецПроцедуры

Процедура СозданиеТочкиИОчереди(КлиентКомпоненты, НастройкиПодключения) Экспорт
	
	Попытка
		КлиентКомпоненты.Connect(
			НастройкиПодключения.Адрес,
			НастройкиПодключения.Порт,
			НастройкиПодключения.Логин,
			НастройкиПодключения.Пароль,
			НастройкиПодключения.ВиртуальныйХост);
			
		ТочкаОбмена = НастройкиПодключения.ТочкаОбмена;
		ИмяОчереди  = НастройкиПодключения.ИмяОчереди; 
		
		КлиентКомпоненты.DeclareExchange(ТочкаОбмена, "topic", Ложь, Истина, Ложь);
		КлиентКомпоненты.DeclareQueue(ИмяОчереди, Истина, Ложь, Ложь, Ложь);
		КлиентКомпоненты.BindQueue(ИмяОчереди, ТочкаОбмена, "#" + ИмяОчереди + "#");
	Исключение
		СистемнаяОшибка = ОписаниеОшибки();
		ТекстСообщения = "Ошибка создания точек и очередей!%СистемнаяОшибка%";
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СистемнаяОшибка%", СистемнаяОшибка);  
		Сообщить(КлиентКомпоненты.GetLastError());
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
	
	Сообщить("Точки и очереди успешно созданы!");
КонецПроцедуры

Процедура ОтправитьСообщение(КлиентКомпоненты, НастройкиПодключения, Знач ТекстСообщения) Экспорт
	
	Попытка
		КлиентКомпоненты.Connect(
			НастройкиПодключения.Адрес,
			НастройкиПодключения.Порт,
			НастройкиПодключения.Логин,
			НастройкиПодключения.Пароль,
			НастройкиПодключения.ВиртуальныйХост);
		
		ТочкаОбмена    = НастройкиПодключения.ТочкаОбмена;
		ИмяОчереди     = НастройкиПодключения.ИмяОчереди;
	
		КлиентКомпоненты.BasicPublish(ТочкаОбмена, "#" + ИмяОчереди + "#", ТекстСообщения, 1000, Ложь);
	Исключение
		СистемнаяОшибка = ОписаниеОшибки();
		ТекстОшибки = "Ошибка отправки сообщения!%СистемнаяОшибка%";
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%СистемнаяОшибка%", СистемнаяОшибка);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Сообщить("Сообщение успешно отправлено!");
КонецПроцедуры

Функция ПрочитатьСообщение(КлиентКомпоненты, НастройкиПодключения) Экспорт
	
	Попытка
		КлиентКомпоненты.Connect(
		НастройкиПодключения.Адрес,
		НастройкиПодключения.Порт,
		НастройкиПодключения.Логин,
		НастройкиПодключения.Пароль,
		НастройкиПодключения.ВиртуальныйХост);
		
		ТочкаОбмена = НастройкиПодключения.ТочкаОбмена;			
		ИмяОчереди = НастройкиПодключения.ИмяОчереди;
		Таймаут = НастройкиПодключения.Таймаут; 
		НеЖдать = Ложь; //noConfirm
		ТегСообщения = 0;   
		
		Попытка   
			Потребитель = КлиентКомпоненты.BasicConsume(ИмяОчереди, "", НеЖдать, Ложь, 0);
			
			ОтветноеСообщение = "";
			Если КлиентКомпоненты.BasicConsumeMessage("", ОтветноеСообщение, ТегСообщения, Таймаут) Тогда
				КлиентКомпоненты.BasicAck(ТегСообщения);
				ТегСообщения = 0;
				
				Ответ = ОтветноеСообщение;
				ТекстСообщения = НСтр("ru='Сообщение успешно прочитано!'");
			Иначе
				Ответ = ОтветноеСообщение;
				ТекстСообщения = НСтр("ru='Очередь пустая!'");
			КонецЕсли;
			
			Сообщить(ТекстСообщения);
			
			ОтветноеСообщение = "";
			
			КлиентКомпоненты.BasicCancel("");
		Исключение
			ВызватьИсключение КлиентКомпоненты.GetLastError();
		КонецПопытки;
	Исключение
		СистемнаяОшибка = ОписаниеОшибки();
		ТекстОшибки = "Ошибка чтения сообщения!%СистемнаяОшибка%";
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%СистемнаяОшибка%", СистемнаяОшибка);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Возврат Ответ;
КонецФункции

#КонецОбласти 

#Область Сериализация                                                                 

Функция Сериализовать(ОбъектСериализации) Экспорт
	ОбъектXDTO = СериализаторXDTO.ЗаписатьXDTO(ОбъектСериализации);
	ЗаписьXMLОбъект = Новый ЗаписьXML;
	ЗаписьXMLОбъект.УстановитьСтроку();
	ПараметрыЗаписиXML = Новый ПараметрыЗаписиXML("UTF-8", "1.0", Ложь);
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXMLОбъект, ОбъектXDTO);
	Возврат ЗаписьXMLОбъект.Закрыть();
КонецФункции

Функция Десериализовать(ДанныеXML) Экспорт
	ЧтениеXMLОбъект = Новый ЧтениеXML;
	ЧтениеXMLОбъект.УстановитьСтроку(ДанныеXML);
	ДесериализованныйОбъект = СериализаторXDTO.ПрочитатьXML(ЧтениеXMLОбъект);
	ЧтениеXMLОбъект.Закрыть();
	Возврат ДесериализованныйОбъект;
КонецФункции

Функция СериализоватьВJSON(Данные) Экспорт
	Попытка
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, ,Истина));
		ЗаписатьJSON(ЗаписьJSON, Данные);
		ПараметрыJSON = ЗаписьJSON.Закрыть();
		Возврат ПараметрыJSON;
	Исключение
		Сообщить("Ошибка JSON");
		Возврат "{}";
	КонецПопытки;
КонецФункции

Функция ДесериализоватьИзJSON(СтрокаJSON) Экспорт
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);   
	Результат = Неопределено;
	Результат = ПрочитатьJSON(ЧтениеJSON,, "Период,Дата,Data", ФорматДатыJSON.ISO);	
	ЧтениеJSON.Закрыть();
	
    Возврат Результат;
КонецФункции

#КонецОбласти