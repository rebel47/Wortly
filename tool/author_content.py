"""Reproducible, original starter content. Not a complete or reviewed corpus.

Rows: headword|type|article|plural|meaning|German example|English example|German example|English example
IDs derive from lemma + type, never rank. Keep this authoring source in version control.
"""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ROWS = """
Anfang|noun|der|Anfänge|beginning|Jeder Anfang braucht ein wenig Mut.|Every beginning takes a little courage.|Das ist erst der Anfang.|This is only the beginning.
lernen|verb|||to learn|Ich lerne jeden Tag ein neues Wort.|I learn a new word every day.|Wir lernen zusammen Deutsch.|We are learning German together.
Zeit|noun|die|Zeiten|time|Hast du heute Abend Zeit?|Do you have time this evening?|Ich nehme mir Zeit für ein gutes Buch.|I make time for a good book.
heute|adverb|||today|Heute bleibe ich zu Hause.|Today I am staying at home.|Was möchtest du heute machen?|What would you like to do today?
gehen|verb|||to go|Wir gehen zu Fuß zum Bahnhof.|We walk to the station.|Ich gehe jetzt nach Hause.|I am going home now.
Wasser|noun|das|—|water|Möchtest du ein Glas Wasser?|Would you like a glass of water?|Das Wasser im See ist kalt.|The water in the lake is cold.
gut|adjective|||good|Das ist eine gute Idee.|That is a good idea.|Die Suppe schmeckt gut.|The soup tastes good.
kommen|verb|||to come|Kommst du morgen auch?|Are you coming tomorrow too?|Der Bus kommt in fünf Minuten.|The bus is coming in five minutes.
Tag|noun|der|Tage|day|Ich wünsche dir einen schönen Tag.|I wish you a lovely day.|Der Tag beginnt mit einer Tasse Tee.|The day begins with a cup of tea.
bitte|particle|||please|Ein Brot, bitte.|One loaf of bread, please.|Kannst du bitte das Fenster öffnen?|Could you please open the window?
danke|particle|||thank you|Danke für deine Hilfe.|Thank you for your help.|Vielen Dank für den schönen Abend.|Thank you very much for the lovely evening.
machen|verb|||to do; to make|Was machst du am Wochenende?|What are you doing at the weekend?|Ich mache uns einen Kaffee.|I am making us some coffee.
Haus|noun|das|Häuser|house|Unser Haus steht neben einem Park.|Our house is next to a park.|Vor dem Haus wächst ein Baum.|A tree grows in front of the house.
klein|adjective|||small|Wir wohnen in einer kleinen Wohnung.|We live in a small apartment.|Die Tasche ist zu klein.|The bag is too small.
groß|adjective|||big; tall|Der Garten ist sehr groß.|The garden is very big.|Mein Bruder ist größer als ich.|My brother is taller than me.
essen|verb|||to eat|Wir essen heute zusammen.|We are eating together today.|Was isst du gern zum Frühstück?|What do you like to eat for breakfast?
trinken|verb|||to drink|Ich trinke morgens gern Tee.|I like to drink tea in the morning.|Vergiss nicht, genug zu trinken.|Do not forget to drink enough.
Brot|noun|das|Brote|bread|Das Brot ist noch warm.|The bread is still warm.|Ich kaufe ein Brot beim Bäcker.|I buy a loaf of bread at the bakery.
morgen|adverb|||tomorrow|Morgen habe ich frei.|Tomorrow I have the day off.|Wir sehen uns morgen.|We will see each other tomorrow.
Freund|noun|der|Freunde|friend (male)|Ein Freund hilft mir beim Umzug.|A friend is helping me move.|Ich treffe meinen Freund im Café.|I am meeting my friend at the café.
Freundin|noun|die|Freundinnen|friend (female)|Meine Freundin wohnt in Berlin.|My friend lives in Berlin.|Ich rufe später eine Freundin an.|I will call a friend later.
sprechen|verb|||to speak|Sprichst du Englisch?|Do you speak English?|Wir sprechen über unsere Pläne.|We are talking about our plans.
verstehen|verb|||to understand|Ich verstehe die Frage nicht.|I do not understand the question.|Jetzt verstehe ich den Unterschied.|Now I understand the difference.
Frage|noun|die|Fragen|question|Darf ich eine Frage stellen?|May I ask a question?|Die Frage ist gar nicht so leicht.|The question is not that easy.
Antwort|noun|die|Antworten|answer|Ich warte auf deine Antwort.|I am waiting for your answer.|Auf diese Frage gibt es keine einfache Antwort.|There is no simple answer to this question.
wohnen|verb|||to live; to reside|Wo wohnst du?|Where do you live?|Wir wohnen seit einem Jahr hier.|We have lived here for a year.
Stadt|noun|die|Städte|city; town|Die Stadt hat viele schöne Parks.|The city has many beautiful parks.|Ich fahre morgen in die Stadt.|I am going into town tomorrow.
Straße|noun|die|Straßen|street; road|Die Straße ist heute gesperrt.|The road is closed today.|Unser Café liegt in einer ruhigen Straße.|Our café is on a quiet street.
Weg|noun|der|Wege|way; path|Kennst du den Weg zum Bahnhof?|Do you know the way to the station?|Dieser Weg führt zum See.|This path leads to the lake.
suchen|verb|||to look for|Ich suche meine Schlüssel.|I am looking for my keys.|Wir suchen eine neue Wohnung.|We are looking for a new apartment.
finden|verb|||to find|Ich finde mein Handy nicht.|I cannot find my phone.|Hier findest du alle Informationen.|You will find all the information here.
brauchen|verb|||to need|Brauchst du Hilfe?|Do you need help?|Für die Suppe brauchen wir noch Salz.|We still need salt for the soup.
Hilfe|noun|die|Hilfen|help; assistance|Danke für deine Hilfe beim Lernen.|Thank you for your help with studying.|Bei Fragen bekommst du hier Hilfe.|You can get help here if you have questions.
kaufen|verb|||to buy|Ich kaufe Gemüse auf dem Markt.|I buy vegetables at the market.|Wo kann ich eine Fahrkarte kaufen?|Where can I buy a ticket?
Geld|noun|das|Gelder|money|Ich habe kein Bargeld, nur eine Karte.|I have no cash, only a card.|Wir sparen Geld für eine Reise.|We are saving money for a trip.
bezahlen|verb|||to pay|Kann ich mit Karte bezahlen?|Can I pay by card?|Ich bezahle die Rechnung heute.|I am paying the bill today.
Arbeit|noun|die|Arbeiten|work; job|Meine Arbeit macht mir Spaß.|I enjoy my work.|Nach der Arbeit gehe ich spazieren.|I go for a walk after work.
arbeiten|verb|||to work|Ich arbeite heute von zu Hause.|I am working from home today.|Sie arbeitet in einem Krankenhaus.|She works in a hospital.
Pause|noun|die|Pausen|break|Wir machen eine kurze Pause.|We are taking a short break.|In der Pause trinke ich einen Kaffee.|I drink a coffee during the break.
schön|adjective|||beautiful; lovely|Was für ein schöner Morgen!|What a beautiful morning!|Der Ausflug war wirklich schön.|The outing was really lovely.
neu|adjective|||new|Ich habe eine neue Nachbarin.|I have a new neighbor.|Heute probieren wir etwas Neues.|Today we are trying something new.
alt|adjective|||old|Wie alt ist dein Hund?|How old is your dog?|In der Altstadt stehen viele alte Häuser.|There are many old houses in the old town.
geben|verb|||to give|Kannst du mir das Buch geben?|Can you give me the book?|Heute gibt es frische Erdbeeren.|There are fresh strawberries today.
nehmen|verb|||to take|Ich nehme den nächsten Bus.|I will take the next bus.|Nimm dir noch ein Stück Kuchen.|Help yourself to another piece of cake.
sehen|verb|||to see|Von hier sehe ich die Berge.|I can see the mountains from here.|Wir sehen uns am Samstag.|We will see each other on Saturday.
hören|verb|||to hear; to listen|Ich höre gern Musik beim Kochen.|I like listening to music while cooking.|Kannst du mich gut hören?|Can you hear me clearly?
lesen|verb|||to read|Sie liest jeden Abend ein paar Seiten.|She reads a few pages every evening.|Kannst du dieses Wort lesen?|Can you read this word?
schreiben|verb|||to write|Ich schreibe dir morgen eine Nachricht.|I will write you a message tomorrow.|Schreib bitte deinen Namen hierhin.|Please write your name here.
Buch|noun|das|Bücher|book|Das Buch liegt auf dem Tisch.|The book is on the table.|Ich leihe mir ein Buch aus der Bibliothek.|I borrow a book from the library.
Wort|noun|das|Wörter|word|Was bedeutet dieses Wort?|What does this word mean?|Dieses Wort möchte ich mir merken.|I want to remember this word.
Sprache|noun|die|Sprachen|language|Welche Sprachen sprichst du?|Which languages do you speak?|Eine neue Sprache öffnet viele Türen.|A new language opens many doors.
Name|noun|der|Namen|name|Wie ist dein Name?|What is your name?|Ich habe deinen Namen vergessen.|I have forgotten your name.
Familie|noun|die|Familien|family|Am Sonntag besuche ich meine Familie.|On Sunday I visit my family.|Meine Familie lebt in einer anderen Stadt.|My family lives in another city.
Kind|noun|das|Kinder|child|Das Kind spielt im Garten.|The child is playing in the garden.|Die Kinder gehen zusammen zur Schule.|The children go to school together.
Frau|noun|die|Frauen|woman; wife|Die Frau an der Kasse ist sehr freundlich.|The woman at the checkout is very friendly.|Meine Frau kommt etwas später.|My wife is coming a little later.
Mann|noun|der|Männer|man; husband|Der Mann wartet an der Haltestelle.|The man is waiting at the stop.|Mein Mann kocht heute Abend.|My husband is cooking this evening.
Mutter|noun|die|Mütter|mother|Meine Mutter besucht uns am Wochenende.|My mother is visiting us at the weekend.|Die Mutter liest ihrem Kind vor.|The mother is reading to her child.
Vater|noun|der|Väter|father|Mein Vater fährt gern Fahrrad.|My father likes cycling.|Der Vater holt die Kinder ab.|The father is picking up the children.
Zeitung|noun|die|Zeitungen|newspaper|Ich lese morgens die Zeitung.|I read the newspaper in the morning.|Die Zeitung liegt neben der Tür.|The newspaper is next to the door.
Nachricht|noun|die|Nachrichten|message; news item|Ich habe dir eine Nachricht geschickt.|I have sent you a message.|Das sind gute Nachrichten!|That is good news!
Telefon|noun|das|Telefone|telephone|Das Telefon klingelt schon wieder.|The telephone is ringing again.|Kann ich kurz dein Telefon benutzen?|May I use your telephone for a moment?
Handy|noun|das|Handys|mobile phone|Mein Handy ist fast leer.|My phone is almost out of battery.|Bitte schalte dein Handy leise.|Please put your phone on silent.
warten|verb|||to wait|Ich warte vor dem Eingang auf dich.|I am waiting for you in front of the entrance.|Wir müssen noch zehn Minuten warten.|We have to wait another ten minutes.
fahren|verb|||to travel by vehicle; to drive|Ich fahre mit dem Zug nach Hamburg.|I am taking the train to Hamburg.|Fährst du heute mit dem Auto?|Are you driving today?
Bus|noun|der|Busse|bus|Der Bus hält direkt vor der Schule.|The bus stops right in front of the school.|Ich habe den letzten Bus verpasst.|I missed the last bus.
Zug|noun|der|Züge|train|Unser Zug fährt von Gleis drei ab.|Our train departs from platform three.|Der Zug hat zehn Minuten Verspätung.|The train is ten minutes late.
Bahnhof|noun|der|Bahnhöfe|train station|Wie komme ich zum Bahnhof?|How do I get to the train station?|Wir treffen uns vor dem Bahnhof.|We will meet in front of the train station.
Fahrkarte|noun|die|Fahrkarten|travel ticket|Eine Fahrkarte nach Bonn, bitte.|A ticket to Bonn, please.|Du kannst die Fahrkarte am Automaten kaufen.|You can buy the ticket at the machine.
Fahrrad|noun|das|Fahrräder|bicycle|Ich fahre mit dem Fahrrad zur Arbeit.|I cycle to work.|Mein Fahrrad braucht einen neuen Reifen.|My bicycle needs a new tire.
Auto|noun|das|Autos|car|Das Auto steht hinter dem Haus.|The car is behind the house.|Wir teilen uns ein Auto.|We share a car.
links|adverb|||left|Biegen Sie an der Ampel links ab.|Turn left at the traffic lights.|Der Eingang ist links neben der Bäckerei.|The entrance is on the left next to the bakery.
rechts|adverb|||right|Die Apotheke ist gleich rechts.|The pharmacy is just on the right.|An der nächsten Kreuzung musst du rechts abbiegen.|You need to turn right at the next junction.
geradeaus|adverb|||straight ahead|Gehen Sie noch zweihundert Meter geradeaus.|Go straight ahead for another two hundred meters.|Der Weg führt immer geradeaus.|The path goes straight ahead all the way.
hier|adverb|||here|Ist hier noch ein Platz frei?|Is this seat free?|Hier fühle ich mich wohl.|I feel at home here.
dort|adverb|||there|Dort drüben ist der Park.|The park is over there.|Wir waren gestern schon dort.|We were there yesterday already.
nah|adjective|||near; close|Der Supermarkt ist ganz nah.|The supermarket is very close.|Wir wohnen nah am Bahnhof.|We live close to the station.
weit|adjective|||far; wide|Wie weit ist es noch bis zum See?|How far is it to the lake now?|Von hier ist es nicht mehr weit.|It is not far from here anymore.
schnell|adjective|||fast; quick|Der neue Zug ist sehr schnell.|The new train is very fast.|Ich mache schnell das Fenster zu.|I will quickly close the window.
langsam|adjective|||slow|Sprich bitte etwas langsamer.|Please speak a little more slowly.|Wir gehen langsam durch den Park.|We walk slowly through the park.
spät|adjective|||late|Es ist schon spät.|It is late already.|Heute komme ich etwas später nach Hause.|Today I am coming home a little later.
früh|adjective|||early|Ich stehe morgen früh auf.|I am getting up early tomorrow.|Für das Abendessen ist es noch zu früh.|It is still too early for dinner.
Uhr|noun|die|Uhren|clock; watch|Meine Uhr geht fünf Minuten vor.|My watch is five minutes fast.|Wir treffen uns um acht Uhr.|We will meet at eight o’clock.
Stunde|noun|die|Stunden|hour|Die Fahrt dauert eine Stunde.|The journey takes an hour.|In einer Stunde bin ich wieder da.|I will be back in an hour.
Minute|noun|die|Minuten|minute|Warte bitte eine Minute.|Please wait a minute.|Der Film beginnt in zehn Minuten.|The film starts in ten minutes.
Woche|noun|die|Wochen|week|Nächste Woche habe ich Urlaub.|Next week I am on vacation.|Wir sehen uns einmal in der Woche.|We see each other once a week.
Monat|noun|der|Monate|month|Ich wohne seit einem Monat hier.|I have lived here for a month.|Jeden Monat lege ich etwas Geld zur Seite.|Every month I put some money aside.
Jahr|noun|das|Jahre|year|Dieses Jahr lernen wir Deutsch.|This year we are learning German.|Vor einem Jahr bin ich umgezogen.|I moved a year ago.
Montag|noun|der|Montage|Monday|Am Montag beginnt mein neuer Kurs.|My new course starts on Monday.|Montags hat die Bäckerei geschlossen.|The bakery is closed on Mondays.
Dienstag|noun|der|Dienstage|Tuesday|Wir treffen uns am Dienstag.|We will meet on Tuesday.|Dienstags gehe ich schwimmen.|I go swimming on Tuesdays.
Mittwoch|noun|der|Mittwoche|Wednesday|Am Mittwoch habe ich einen Termin.|I have an appointment on Wednesday.|Mittwochs findet der Markt statt.|The market takes place on Wednesdays.
Donnerstag|noun|der|Donnerstage|Thursday|Die Ausstellung eröffnet am Donnerstag.|The exhibition opens on Thursday.|Donnerstags arbeite ich länger.|I work longer on Thursdays.
Freitag|noun|der|Freitage|Friday|Am Freitag kommen Freunde zu Besuch.|Friends are coming to visit on Friday.|Freitags kaufen wir für die Woche ein.|On Fridays we do the shopping for the week.
Samstag|noun|der|Samstage|Saturday|Am Samstag schlafen wir länger.|We sleep in on Saturday.|Samstags ist der Markt besonders voll.|The market is especially busy on Saturdays.
Sonntag|noun|der|Sonntage|Sunday|Am Sonntag machen wir einen Ausflug.|We are going on an outing on Sunday.|Sonntags nehme ich mir Zeit zum Lesen.|On Sundays I make time to read.
Wochenende|noun|das|Wochenenden|weekend|Was hast du am Wochenende vor?|What are your plans for the weekend?|Wir wünschen euch ein schönes Wochenende.|We wish you a lovely weekend.
Frühstück|noun|das|—|breakfast|Zum Frühstück esse ich Brot mit Käse.|I eat bread with cheese for breakfast.|Das Frühstück ist schon fertig.|Breakfast is ready already.
Mittagessen|noun|das|Mittagessen|lunch|Wir treffen uns zum Mittagessen.|We are meeting for lunch.|Das Mittagessen gibt es um zwölf.|Lunch is at twelve.
Abendessen|noun|das|Abendessen|dinner; evening meal|Was gibt es heute zum Abendessen?|What is for dinner today?|Nach dem Abendessen machen wir einen Spaziergang.|We go for a walk after dinner.
Kaffee|noun|der|Kaffees|coffee|Ich trinke meinen Kaffee ohne Zucker.|I drink my coffee without sugar.|Möchtest du noch einen Kaffee?|Would you like another coffee?
Tee|noun|der|Tees|tea|Eine Tasse Tee wärmt meine Hände.|A cup of tea warms my hands.|Lass den Tee drei Minuten ziehen.|Let the tea steep for three minutes.
Milch|noun|die|—|milk|Wir brauchen noch Milch für morgen.|We still need milk for tomorrow.|Trinkst du deinen Kaffee mit Milch?|Do you drink your coffee with milk?
Ei|noun|das|Eier|egg|Zum Frühstück koche ich ein Ei.|I boil an egg for breakfast.|Für den Kuchen brauchen wir drei Eier.|We need three eggs for the cake.
Käse|noun|der|Käse|cheese|Welchen Käse möchtest du probieren?|Which cheese would you like to try?|Der Käse kommt aus der Region.|The cheese comes from the region.
Obst|noun|das|—|fruit|Ich esse jeden Tag frisches Obst.|I eat fresh fruit every day.|Das Obst liegt in der Schale.|The fruit is in the bowl.
Gemüse|noun|das|—|vegetables|Schneide bitte das Gemüse klein.|Please chop the vegetables finely.|Auf dem Markt gibt es frisches Gemüse.|There are fresh vegetables at the market.
Apfel|noun|der|Äpfel|apple|Der Apfel schmeckt süß und frisch.|The apple tastes sweet and fresh.|Ich packe einen Apfel für unterwegs ein.|I pack an apple for the journey.
Kartoffel|noun|die|Kartoffeln|potato|Die Kartoffeln müssen noch zehn Minuten kochen.|The potatoes need to cook for another ten minutes.|Wir pflanzen Kartoffeln im Garten.|We plant potatoes in the garden.
Tomate|noun|die|Tomaten|tomato|Die Tomaten sind endlich reif.|The tomatoes are finally ripe.|Ich schneide eine Tomate für den Salat.|I slice a tomato for the salad.
Salat|noun|der|Salate|salad; lettuce|Zum Essen gibt es einen frischen Salat.|There is a fresh salad with the meal.|Der Salat wächst auf dem Balkon.|The lettuce grows on the balcony.
Suppe|noun|die|Suppen|soup|Die Suppe ist noch zu heiß.|The soup is still too hot.|Im Winter koche ich oft Suppe.|I often make soup in winter.
Salz|noun|das|Salze|salt|Der Suppe fehlt noch etwas Salz.|The soup needs a little more salt.|Reichst du mir bitte das Salz?|Could you pass me the salt?
Zucker|noun|der|—|sugar|Ich nehme keinen Zucker im Tee.|I do not take sugar in my tea.|Für das Rezept brauchen wir wenig Zucker.|We need only a little sugar for the recipe.
Rechnung|noun|die|Rechnungen|bill; invoice|Die Rechnung, bitte.|The bill, please.|Ich habe die Rechnung schon bezahlt.|I have already paid the bill.
Speisekarte|noun|die|Speisekarten|menu|Dürfen wir die Speisekarte sehen?|May we see the menu?|Auf der Speisekarte stehen auch vegetarische Gerichte.|There are vegetarian dishes on the menu too.
bestellen|verb|||to order|Ich möchte einen Tee bestellen.|I would like to order a tea.|Wir bestellen die Bücher online.|We order the books online.
kochen|verb|||to cook; to boil|Heute koche ich für meine Freunde.|Today I am cooking for my friends.|Das Wasser kocht schon.|The water is boiling already.
schmecken|verb|||to taste|Schmeckt dir die Suppe?|Do you like the taste of the soup?|Das Brot schmeckt heute besonders gut.|The bread tastes especially good today.
hungrig|adjective|||hungry|Nach dem Spaziergang bin ich hungrig.|I am hungry after the walk.|Bist du schon hungrig?|Are you hungry already?
durstig|adjective|||thirsty|Nach dem Sport bin ich sehr durstig.|I am very thirsty after exercise.|Die Kinder sind durstig und möchten Wasser.|The children are thirsty and would like water.
warm|adjective|||warm|Heute ist es draußen angenehm warm.|It is pleasantly warm outside today.|Die Jacke hält mich warm.|The jacket keeps me warm.
kalt|adjective|||cold|Mir ist kalt. Machst du das Fenster zu?|I am cold. Could you close the window?|Im Winter wird der See sehr kalt.|The lake gets very cold in winter.
heiß|adjective|||hot|Vorsicht, der Tee ist heiß.|Careful, the tea is hot.|Morgen soll es richtig heiß werden.|It is supposed to get really hot tomorrow.
frisch|adjective|||fresh|Morgens kaufen wir frisches Brot.|We buy fresh bread in the morning.|Nach dem Regen riecht die Luft frisch.|The air smells fresh after the rain.
Wohnung|noun|die|Wohnungen|apartment; flat|Unsere Wohnung hat zwei Zimmer.|Our apartment has two rooms.|Ich suche eine Wohnung mit Balkon.|I am looking for an apartment with a balcony.
Zimmer|noun|das|Zimmer|room|Mein Zimmer ist klein, aber hell.|My room is small but bright.|Wir haben ein Zimmer für zwei Nächte gebucht.|We have booked a room for two nights.
Küche|noun|die|Küchen|kitchen|In der Küche riecht es nach Kaffee.|The kitchen smells of coffee.|Unsere Küche hat ein großes Fenster.|Our kitchen has a large window.
Bad|noun|das|Bäder|bathroom; bath|Das Bad ist am Ende des Flurs.|The bathroom is at the end of the hallway.|Nach der Wanderung nehme ich ein warmes Bad.|I take a warm bath after the hike.
Tür|noun|die|Türen|door|Mach bitte die Tür hinter dir zu.|Please close the door behind you.|Jemand steht vor der Tür.|Someone is standing at the door.
Fenster|noun|das|Fenster|window|Kann ich das Fenster öffnen?|May I open the window?|Am Fenster stehen zwei Pflanzen.|There are two plants by the window.
Tisch|noun|der|Tische|table|Wir sitzen zusammen am Tisch.|We are sitting together at the table.|Stell die Tasse bitte auf den Tisch.|Please put the cup on the table.
Stuhl|noun|der|Stühle|chair|Ist dieser Stuhl noch frei?|Is this chair free?|Ich hole noch einen Stuhl aus der Küche.|I will get another chair from the kitchen.
Bett|noun|das|Betten|bed|Heute gehe ich früh ins Bett.|Today I am going to bed early.|Das Bett steht neben dem Fenster.|The bed is next to the window.
Schlüssel|noun|der|Schlüssel|key|Hast du deinen Schlüssel dabei?|Do you have your key with you?|Der Schlüssel liegt in meiner Tasche.|The key is in my bag.
Tasche|noun|die|Taschen|bag; pocket|Meine Tasche ist ziemlich schwer.|My bag is quite heavy.|Ich stecke den Schlüssel in die Tasche.|I put the key in my pocket.
Kleidung|noun|die|—|clothing|Für die Wanderung brauche ich warme Kleidung.|I need warm clothing for the hike.|Die Kleidung trocknet auf dem Balkon.|The clothing is drying on the balcony.
Jacke|noun|die|Jacken|jacket|Nimm eine Jacke mit, es wird kühl.|Take a jacket; it is getting chilly.|Meine Jacke hängt an der Tür.|My jacket is hanging on the door.
Schuh|noun|der|Schuhe|shoe|Diese Schuhe sind sehr bequem.|These shoes are very comfortable.|Vor der Tür stehen nasse Schuhe.|There are wet shoes in front of the door.
tragen|verb|||to wear; to carry|Sie trägt heute eine blaue Jacke.|She is wearing a blue jacket today.|Kannst du diese Tasche tragen?|Can you carry this bag?
öffnen|verb|||to open|Der Laden öffnet um neun.|The shop opens at nine.|Öffne bitte die Tür.|Please open the door.
schließen|verb|||to close|Das Museum schließt heute früher.|The museum closes earlier today.|Bitte schließen Sie das Fenster.|Please close the window.
schlafen|verb|||to sleep|Ich habe letzte Nacht gut geschlafen.|I slept well last night.|Das Baby schläft schon.|The baby is asleep already.
aufstehen|verb|||to get up|Ich stehe jeden Morgen um sieben auf.|I get up at seven every morning.|Am Sonntag stehe ich später auf.|On Sunday I get up later.
aufwachen|verb|||to wake up|Ich wache oft vor dem Wecker auf.|I often wake up before the alarm.|Heute bin ich früh aufgewacht.|Today I woke up early.
müde|adjective|||tired|Nach der langen Fahrt bin ich müde.|I am tired after the long journey.|Bist du noch nicht müde?|Are you not tired yet?
gesund|adjective|||healthy|Frisches Gemüse gehört zu einer gesunden Ernährung.|Fresh vegetables are part of a healthy diet.|Ich hoffe, du bleibst gesund.|I hope you stay healthy.
krank|adjective|||ill; sick|Ich bin krank und bleibe heute zu Hause.|I am ill and am staying home today.|Meine Kollegin ist seit Montag krank.|My colleague has been ill since Monday.
Arzt|noun|der|Ärzte|doctor (male)|Ich habe morgen einen Termin beim Arzt.|I have a doctor’s appointment tomorrow.|Der Arzt erklärt mir die Behandlung.|The doctor explains the treatment to me.
Ärztin|noun|die|Ärztinnen|doctor (female)|Die Ärztin hört mir aufmerksam zu.|The doctor listens to me carefully.|Meine Ärztin hat heute keine Sprechstunde.|My doctor is not holding office hours today.
Apotheke|noun|die|Apotheken|pharmacy|Die nächste Apotheke ist am Marktplatz.|The nearest pharmacy is on the market square.|Ich hole das Medikament in der Apotheke ab.|I pick up the medication at the pharmacy.
Termin|noun|der|Termine|appointment|Ich möchte einen Termin vereinbaren.|I would like to make an appointment.|Passt dir der Termin am Freitag?|Does the appointment on Friday suit you?
Kopf|noun|der|Köpfe|head|Nach der Arbeit tut mir der Kopf weh.|My head hurts after work.|Setz eine Mütze auf den Kopf.|Put a hat on your head.
Hand|noun|die|Hände|hand|Wasch dir bitte die Hände.|Please wash your hands.|Sie hält die Tasse in beiden Händen.|She holds the cup in both hands.
Fuß|noun|der|Füße|foot|Wir gehen zu Fuß nach Hause.|We are walking home.|Nach der Wanderung tun mir die Füße weh.|My feet hurt after the hike.
Wetter|noun|das|—|weather|Wie wird das Wetter morgen?|What will the weather be like tomorrow?|Bei diesem Wetter bleiben wir drinnen.|We are staying inside in this weather.
Sonne|noun|die|Sonnen|sun|Heute scheint endlich wieder die Sonne.|The sun is finally shining again today.|Wir sitzen gern in der Sonne.|We like sitting in the sun.
Regen|noun|der|—|rain|Der Regen hört langsam auf.|The rain is slowly stopping.|Nach dem Regen gehen wir spazieren.|We will go for a walk after the rain.
Wind|noun|der|Winde|wind|Heute weht ein starker Wind.|A strong wind is blowing today.|Der Wind bewegt die Blätter.|The wind moves the leaves.
Schnee|noun|der|—|snow|Auf den Bergen liegt noch Schnee.|There is still snow on the mountains.|Die Kinder spielen im Schnee.|The children are playing in the snow.
Baum|noun|der|Bäume|tree|Unter dem Baum steht eine Bank.|There is a bench under the tree.|Im Herbst verliert der Baum seine Blätter.|The tree loses its leaves in autumn.
Blume|noun|die|Blumen|flower|Auf dem Tisch steht eine gelbe Blume.|There is a yellow flower on the table.|Ich bringe dir Blumen aus dem Garten mit.|I will bring you flowers from the garden.
Garten|noun|der|Gärten|garden|Wir pflanzen Kräuter im Garten.|We plant herbs in the garden.|Im Garten ist es morgens ganz still.|It is very quiet in the garden in the morning.
Park|noun|der|Parks|park|Nach der Arbeit laufe ich durch den Park.|I walk through the park after work.|Im Park blühen schon die ersten Blumen.|The first flowers are blooming in the park already.
Wald|noun|der|Wälder|forest; woods|Im Wald hören wir die Vögel.|We hear the birds in the forest.|Dieser Weg führt durch einen dichten Wald.|This path leads through a dense forest.
See|noun|der|Seen|lake|Wir schwimmen im Sommer gern im See.|We like swimming in the lake in summer.|Am See gibt es einen kleinen Strand.|There is a small beach by the lake.
Berg|noun|der|Berge|mountain|Vom Berg aus sieht man die ganze Stadt.|From the mountain you can see the whole city.|Morgen wandern wir auf einen Berg.|Tomorrow we are hiking up a mountain.
Meer|noun|das|Meere|sea|Im Urlaub fahren wir ans Meer.|We are going to the sea on vacation.|Das Meer ist heute ganz ruhig.|The sea is very calm today.
Reise|noun|die|Reisen|journey; trip|Wir planen eine Reise nach Österreich.|We are planning a trip to Austria.|Gute Reise und bis bald!|Have a good trip and see you soon!
Urlaub|noun|der|Urlaube|vacation; holiday|Wann fährst du in den Urlaub?|When are you going on vacation?|Im Urlaub möchte ich viel lesen.|I want to read a lot on vacation.
Koffer|noun|der|Koffer|suitcase|Mein Koffer ist schon gepackt.|My suitcase is packed already.|Dieser Koffer passt ins Gepäckfach.|This suitcase fits in the luggage compartment.
Hotel|noun|das|Hotels|hotel|Unser Hotel liegt direkt am Fluss.|Our hotel is right by the river.|Haben Sie noch ein Zimmer im Hotel frei?|Do you still have a room available in the hotel?
reservieren|verb|||to reserve; to book|Ich möchte einen Tisch für zwei reservieren.|I would like to reserve a table for two.|Wir haben die Plätze im Zug reserviert.|We have reserved the seats on the train.
ankommen|verb|||to arrive|Wann kommt dein Zug an?|When does your train arrive?|Wir sind gestern Abend angekommen.|We arrived yesterday evening.
abfahren|verb|||to depart|Der Bus fährt in fünf Minuten ab.|The bus departs in five minutes.|Wir fahren morgen früh ab.|We are leaving early tomorrow morning.
bleiben|verb|||to stay|Wie lange bleibst du in Berlin?|How long are you staying in Berlin?|Bei Regen bleiben wir zu Hause.|We stay at home when it rains.
helfen|verb|||to help|Kann ich dir beim Tragen helfen?|Can I help you carry that?|Meine Nachbarin hilft mir mit den Pflanzen.|My neighbor helps me with the plants.
fragen|verb|||to ask|Darf ich dich etwas fragen?|May I ask you something?|Frag am besten an der Information.|It is best to ask at the information desk.
antworten|verb|||to answer; to reply|Ich antworte dir nach der Arbeit.|I will reply to you after work.|Bitte antworten Sie auf diese Nachricht.|Please reply to this message.
denken|verb|||to think|Ich denke oft an unsere Reise.|I often think about our trip.|Was denkst du über diese Idee?|What do you think about this idea?
wissen|verb|||to know a fact|Weißt du, wann der Laden öffnet?|Do you know when the shop opens?|Ich weiß die Antwort noch nicht.|I do not know the answer yet.
kennen|verb|||to know; to be familiar with|Kennst du dieses Restaurant?|Do you know this restaurant?|Wir kennen uns seit der Schule.|We have known each other since school.
vergessen|verb|||to forget|Vergiss bitte deinen Schlüssel nicht.|Please do not forget your key.|Ich habe den Termin vergessen.|I forgot the appointment.
erinnern|verb|||to remind; to remember|Erinnere mich bitte an den Termin.|Please remind me about the appointment.|Ich erinnere mich gern an diesen Sommer.|I like remembering that summer.
versuchen|verb|||to try; to attempt|Ich versuche, jeden Tag Deutsch zu sprechen.|I try to speak German every day.|Versuchen wir es noch einmal.|Let us try it once more.
beginnen|verb|||to begin|Der Kurs beginnt nächste Woche.|The course begins next week.|Wir beginnen mit einer einfachen Frage.|We begin with a simple question.
aufhören|verb|||to stop; to finish|Der Regen hört endlich auf.|The rain is finally stopping.|Wann hörst du heute mit der Arbeit auf?|When do you finish work today?
spielen|verb|||to play|Die Kinder spielen draußen.|The children are playing outside.|Spielst du ein Instrument?|Do you play an instrument?
spazieren|verb|||to stroll; to go for a walk|Wir gehen nach dem Essen spazieren.|We go for a walk after eating.|Am See kann man schön spazieren gehen.|You can take a lovely walk by the lake.
laufen|verb|||to run; to walk|Ich laufe morgens eine Runde im Park.|I go for a run in the park in the morning.|Zum Bahnhof können wir laufen.|We can walk to the station.
schwimmen|verb|||to swim|Im Sommer schwimme ich gern im See.|I like swimming in the lake in summer.|Kannst du schon schwimmen?|Can you swim yet?
treffen|verb|||to meet|Wir treffen uns um sechs im Café.|We are meeting at six at the café.|Ich habe gestern eine alte Freundin getroffen.|I met an old friend yesterday.
besuchen|verb|||to visit|Am Wochenende besuchen wir meine Eltern.|We visit my parents at the weekend.|Möchtest du uns im Sommer besuchen?|Would you like to visit us in summer?
einladen|verb|||to invite|Ich lade dich zum Abendessen ein.|I am inviting you to dinner.|Wir haben unsere Nachbarn eingeladen.|We have invited our neighbors.
zusammen|adverb|||together|Zusammen macht das Lernen mehr Spaß.|Learning is more fun together.|Wollen wir zusammen kochen?|Shall we cook together?
allein|adjective|||alone|Heute bin ich allein zu Hause.|Today I am home alone.|Sie reist gern allein.|She likes traveling alone.
freundlich|adjective|||friendly|Die Nachbarn sind sehr freundlich.|The neighbors are very friendly.|Sie begrüßt uns mit einem freundlichen Lächeln.|She greets us with a friendly smile.
glücklich|adjective|||happy|Ich bin glücklich, dich zu sehen.|I am happy to see you.|Die Kinder spielen glücklich im Garten.|The children are playing happily in the garden.
traurig|adjective|||sad|Der Abschied macht mich traurig.|Saying goodbye makes me sad.|Warum bist du heute so traurig?|Why are you so sad today?
ruhig|adjective|||quiet; calm|Wir suchen ein ruhiges Café.|We are looking for a quiet café.|Am frühen Morgen ist die Stadt noch ruhig.|The city is still quiet in the early morning.
laut|adjective|||loud|Die Musik ist mir zu laut.|The music is too loud for me.|Auf der Baustelle ist es heute laut.|It is loud at the construction site today.
leicht|adjective|||easy; light|Die Tasche ist erstaunlich leicht.|The bag is surprisingly light.|Mit etwas Übung wird es leichter.|It gets easier with a little practice.
schwer|adjective|||heavy; difficult|Dieser Koffer ist sehr schwer.|This suitcase is very heavy.|Die letzte Frage war schwer.|The last question was difficult.
wichtig|adjective|||important|Schlaf ist wichtig für die Gesundheit.|Sleep is important for health.|Ich habe morgen einen wichtigen Termin.|I have an important appointment tomorrow.
richtig|adjective|||correct; right|Ist diese Antwort richtig?|Is this answer correct?|Wir sind auf dem richtigen Weg.|We are on the right path.
falsch|adjective|||wrong; incorrect|Ich bin in den falschen Bus gestiegen.|I got on the wrong bus.|Die Adresse ist leider falsch.|Unfortunately, the address is wrong.
teuer|adjective|||expensive|Die Wohnung ist zu teuer für uns.|The apartment is too expensive for us.|Ist die Fahrkarte am Wochenende teurer?|Is the ticket more expensive at the weekend?
günstig|adjective|||affordable; favorable|Wir haben ein günstiges Hotel gefunden.|We found an affordable hotel.|Der Zeitpunkt ist gerade günstig.|The timing is favorable right now.
offen|adjective|||open|Ist der Laden noch offen?|Is the shop still open?|Lass die Tür bitte offen.|Please leave the door open.
geschlossen|adjective|||closed|Das Museum ist montags geschlossen.|The museum is closed on Mondays.|Wegen des Regens bleiben die Fenster geschlossen.|The windows stay closed because of the rain.
voll|adjective|||full|Der Bus ist heute sehr voll.|The bus is very full today.|Mein Kalender ist diese Woche voll.|My calendar is full this week.
leer|adjective|||empty|Das Glas ist schon leer.|The glass is empty already.|Am frühen Morgen sind die Straßen leer.|The streets are empty in the early morning.
vielleicht|adverb|||perhaps; maybe|Vielleicht regnet es morgen.|Perhaps it will rain tomorrow.|Hast du vielleicht einen Stift für mich?|Do you happen to have a pen for me?
immer|adverb|||always|Ich trinke meinen Tee immer ohne Zucker.|I always drink my tea without sugar.|Du bist hier immer willkommen.|You are always welcome here.
oft|adverb|||often|Wir gehen oft am Fluss spazieren.|We often walk by the river.|Wie oft fährst du mit dem Zug?|How often do you travel by train?
manchmal|adverb|||sometimes|Manchmal nehme ich einen anderen Weg.|Sometimes I take a different route.|Wir kochen manchmal zusammen.|We sometimes cook together.
nie|adverb|||never|Ich war noch nie in Wien.|I have never been to Vienna.|Für eine neue Sprache ist es nie zu spät.|It is never too late for a new language.
schon|adverb|||already|Bist du schon fertig?|Are you finished already?|Ich habe das Buch schon gelesen.|I have already read the book.
noch|adverb|||still; yet|Ich brauche noch ein bisschen Zeit.|I still need a little time.|Der Bus ist noch nicht da.|The bus is not here yet.
wieder|adverb|||again|Schön, dich wieder zu sehen.|It is lovely to see you again.|Morgen versuchen wir es wieder.|Tomorrow we will try again.
gern|adverb|||gladly; with pleasure|Ich lese gern am Abend.|I enjoy reading in the evening.|Ich helfe dir gern.|I am happy to help you.
leider|adverb|||unfortunately|Leider habe ich heute keine Zeit.|Unfortunately, I have no time today.|Der Laden ist leider schon geschlossen.|Unfortunately, the shop is closed already.
warum|adverb|||why|Warum lernst du Deutsch?|Why are you learning German?|Weißt du, warum der Zug nicht fährt?|Do you know why the train is not running?
weil|conjunction|||because|Ich bleibe zu Hause, weil ich müde bin.|I am staying home because I am tired.|Wir gehen zu Fuß, weil das Wetter schön ist.|We are walking because the weather is lovely.
aber|conjunction|||but|Die Wohnung ist klein, aber gemütlich.|The apartment is small but cozy.|Ich möchte kommen, aber ich muss arbeiten.|I would like to come, but I have to work.
und|conjunction|||and|Ich kaufe Brot und Milch.|I am buying bread and milk.|Komm herein und setz dich.|Come in and sit down.
oder|conjunction|||or|Möchtest du Tee oder Kaffee?|Would you like tea or coffee?|Fahren wir mit dem Bus oder gehen wir zu Fuß?|Are we taking the bus or walking?
mit|preposition|||with|Ich fahre mit meiner Schwester ans Meer.|I am going to the sea with my sister.|Einen Kaffee mit Milch, bitte.|A coffee with milk, please.
ohne|preposition|||without|Ich trinke meinen Tee ohne Zucker.|I drink my tea without sugar.|Ohne dich wäre der Abend nicht so schön.|The evening would not be as lovely without you.
für|preposition|||for|Diese Blumen sind für dich.|These flowers are for you.|Ich brauche ein Geschenk für meine Mutter.|I need a present for my mother.
nach|preposition|||after; to|Nach der Arbeit gehe ich einkaufen.|I go shopping after work.|Morgen fahren wir nach Leipzig.|Tomorrow we are going to Leipzig.
vor|preposition|||before; in front of|Wir treffen uns vor dem Kino.|We will meet in front of the cinema.|Vor dem Essen wasche ich mir die Hände.|I wash my hands before eating.
zwischen|preposition|||between|Der Schlüssel liegt zwischen den Büchern.|The key is between the books.|Zwischen zwei Terminen mache ich eine Pause.|I take a break between two appointments.
über|preposition|||above; about|Über dem Tisch hängt eine Lampe.|A lamp hangs above the table.|Wir sprechen über unseren Urlaub.|We are talking about our vacation.
unter|preposition|||under; among|Die Katze schläft unter dem Tisch.|The cat is sleeping under the table.|Unter Freunden fällt das Lernen leichter.|Learning is easier among friends.
neben|preposition|||next to|Setz dich neben mich.|Sit next to me.|Neben dem Bahnhof ist eine Bäckerei.|There is a bakery next to the station.
Schule|noun|die|Schulen|school|Die Schule beginnt um acht Uhr.|School starts at eight o’clock.|Meine Kinder gehen gern zur Schule.|My children like going to school.
Kurs|noun|der|Kurse|course|Mein Deutschkurs findet zweimal pro Woche statt.|My German course takes place twice a week.|In diesem Kurs lernen wir zusammen.|We learn together in this course.
Übung|noun|die|Übungen|exercise; practice|Diese Übung hilft mir beim Lernen.|This exercise helps me learn.|Mit etwas Übung wird es leichter.|It gets easier with a little practice.
Fehler|noun|der|Fehler|mistake; error|Fehler gehören zum Lernen dazu.|Mistakes are part of learning.|Ich habe einen kleinen Fehler gefunden.|I found a small mistake.
Erfolg|noun|der|Erfolge|success|Jeder kleine Erfolg zählt.|Every small success counts.|Wir freuen uns über unseren Erfolg.|We are pleased about our success.
Mut|noun|der|—|courage|Eine neue Sprache zu sprechen braucht Mut.|Speaking a new language takes courage.|Deine Worte machen mir Mut.|Your words give me courage.
Geduld|noun|die|—|patience|Beim Lernen brauche ich Geduld.|I need patience when learning.|Danke für deine Geduld.|Thank you for your patience.
Gewohnheit|noun|die|Gewohnheiten|habit|Lesen ist eine schöne Gewohnheit.|Reading is a lovely habit.|Eine neue Gewohnheit wächst langsam.|A new habit grows slowly.
Ziel|noun|das|Ziele|goal; destination|Mein Ziel ist ein Gespräch auf Deutsch.|My goal is a conversation in German.|Wir sind fast am Ziel.|We are almost at our destination.
Fortschritt|noun|der|Fortschritte|progress|Ich sehe jeden Tag einen kleinen Fortschritt.|I see a little progress every day.|Du machst große Fortschritte.|You are making great progress.
Möglichkeit|noun|die|Möglichkeiten|possibility; opportunity|Es gibt viele Möglichkeiten, Deutsch zu üben.|There are many ways to practice German.|Danke für diese Möglichkeit.|Thank you for this opportunity.
Idee|noun|die|Ideen|idea|Ich habe eine Idee für das Wochenende.|I have an idea for the weekend.|Das ist eine wirklich gute Idee.|That is a really good idea.
Plan|noun|der|Pläne|plan|Was ist dein Plan für morgen?|What is your plan for tomorrow?|Unsere Pläne haben sich geändert.|Our plans have changed.
Grund|noun|der|Gründe|reason; ground|Es gibt keinen Grund zur Sorge.|There is no reason to worry.|Was ist der Grund für die Verspätung?|What is the reason for the delay?
Unterschied|noun|der|Unterschiede|difference|Was ist der Unterschied zwischen diesen Wörtern?|What is the difference between these words?|Ich merke schon einen Unterschied.|I can notice a difference already.
Alltag|noun|der|—|everyday life|Deutsch wird Teil meines Alltags.|German is becoming part of my everyday life.|Ein Spaziergang bringt Ruhe in den Alltag.|A walk brings calm to everyday life.
Nachbar|noun|der|Nachbarn|neighbor (male)|Unser Nachbar gießt die Blumen.|Our neighbor waters the flowers.|Ich habe meinen neuen Nachbarn begrüßt.|I greeted my new neighbor.
Nachbarin|noun|die|Nachbarinnen|neighbor (female)|Meine Nachbarin hat einen Hund.|My neighbor has a dog.|Ich helfe meiner Nachbarin beim Einkaufen.|I help my neighbor with shopping.
Hund|noun|der|Hunde|dog|Unser Hund schläft auf seiner Decke.|Our dog sleeps on his blanket.|Ich gehe mit dem Hund spazieren.|I take the dog for a walk.
Katze|noun|die|Katzen|cat|Die Katze sitzt am Fenster.|The cat is sitting by the window.|Unsere Katze versteckt sich unter dem Bett.|Our cat hides under the bed.
Vogel|noun|der|Vögel|bird|Ein Vogel singt im Baum.|A bird is singing in the tree.|Morgens höre ich viele Vögel.|I hear many birds in the morning.
Lächeln|noun|das|Lächeln|smile|Ein Lächeln macht den Tag schöner.|A smile makes the day lovelier.|Sie begrüßt uns mit einem Lächeln.|She greets us with a smile.
Geschichte|noun|die|Geschichten|story; history|Erzähl mir eine Geschichte.|Tell me a story.|Die Stadt hat eine lange Geschichte.|The city has a long history.
Musik|noun|die|—|music|Beim Kochen höre ich gern Musik.|I like listening to music while cooking.|Welche Musik hörst du am liebsten?|What music do you like listening to most?
Film|noun|der|Filme|film; movie|Heute Abend sehen wir einen Film.|We are watching a film this evening.|Der Film hat mir gut gefallen.|I liked the film.
Kino|noun|das|Kinos|cinema|Gehen wir am Freitag ins Kino?|Shall we go to the cinema on Friday?|Das Kino zeigt auch Filme auf Deutsch.|The cinema also shows films in German.
Bibliothek|noun|die|Bibliotheken|library|Ich leihe Bücher in der Bibliothek aus.|I borrow books from the library.|In der Bibliothek kann ich ruhig lernen.|I can study quietly in the library.
Markt|noun|der|Märkte|market|Samstags kaufen wir auf dem Markt ein.|On Saturdays we shop at the market.|Auf dem Markt gibt es frisches Brot.|There is fresh bread at the market.
Bäckerei|noun|die|Bäckereien|bakery|Die Bäckerei an der Ecke öffnet früh.|The bakery on the corner opens early.|Aus der Bäckerei duftet es nach Brot.|The smell of bread comes from the bakery.
Supermarkt|noun|der|Supermärkte|supermarket|Ich gehe nachher zum Supermarkt.|I am going to the supermarket later.|Der Supermarkt schließt um zwanzig Uhr.|The supermarket closes at eight in the evening.
Laden|noun|der|Läden|shop; store|Der kleine Laden verkauft Bücher.|The little shop sells books.|Ist der Laden am Sonntag offen?|Is the shop open on Sunday?
Geschenk|noun|das|Geschenke|gift; present|Ich suche ein Geschenk für dich.|I am looking for a gift for you.|Vielen Dank für das schöne Geschenk.|Thank you very much for the lovely gift.
Geburtstag|noun|der|Geburtstage|birthday|Wann hast du Geburtstag?|When is your birthday?|Alles Gute zum Geburtstag!|Happy birthday!
Einladung|noun|die|Einladungen|invitation|Vielen Dank für die Einladung.|Thank you very much for the invitation.|Ich habe eine Einladung zum Sommerfest bekommen.|I received an invitation to the summer party.
Gespräch|noun|das|Gespräche|conversation|Das war ein schönes Gespräch.|That was a lovely conversation.|Im Kurs üben wir kurze Gespräche.|We practice short conversations in the course.
Beispiel|noun|das|Beispiele|example|Kannst du mir ein Beispiel geben?|Can you give me an example?|Mit einem Beispiel verstehe ich es besser.|I understand it better with an example.
Satz|noun|der|Sätze|sentence|Dieser Satz ist leicht zu verstehen.|This sentence is easy to understand.|Schreib einen Satz mit dem neuen Wort.|Write a sentence with the new word.
Bedeutung|noun|die|Bedeutungen|meaning|Kennst du die Bedeutung dieses Wortes?|Do you know the meaning of this word?|Dieses Wort hat mehrere Bedeutungen.|This word has several meanings.
Artikel|noun|der|Artikel|grammatical article; article|Lerne den Artikel zusammen mit dem Nomen.|Learn the article together with the noun.|Ich lese einen interessanten Artikel.|I am reading an interesting article.
erklären|verb|||to explain|Kannst du mir den Weg erklären?|Can you explain the way to me?|Die Lehrerin erklärt das neue Wort.|The teacher explains the new word.
wiederholen|verb|||to repeat; to revise|Kannst du den Satz bitte wiederholen?|Could you please repeat the sentence?|Abends wiederhole ich die neuen Wörter.|I revise the new words in the evening.
üben|verb|||to practice|Wir üben heute ein kurzes Gespräch.|We are practicing a short conversation today.|Ich übe jeden Tag ein bisschen.|I practice a little every day.
merken|verb|||to notice; to remember|Ich merke mir das Wort mit einem Beispiel.|I remember the word with an example.|Merkst du den Unterschied?|Do you notice the difference?
fühlen|verb|||to feel|Ich fühle mich heute gut.|I feel good today.|Nach dem Spaziergang fühle ich mich wach.|I feel awake after the walk.
hoffen|verb|||to hope|Ich hoffe auf gutes Wetter.|I am hoping for good weather.|Wir hoffen, dass du bald kommst.|We hope you will come soon.
freuen|verb|||to be pleased; to look forward to|Ich freue mich auf das Wochenende.|I am looking forward to the weekend.|Wir freuen uns über deinen Besuch.|We are pleased about your visit.
lieben|verb|||to love|Ich liebe den Geruch von frischem Brot.|I love the smell of fresh bread.|Sie liebt lange Spaziergänge.|She loves long walks.
mögen|verb|||to like|Ich mag ruhige Morgen.|I like quiet mornings.|Magst du lieber Tee oder Kaffee?|Do you prefer tea or coffee?
möchten|verb|||would like|Ich möchte gern Deutsch lernen.|I would like to learn German.|Möchtest du noch etwas Wasser?|Would you like some more water?
können|verb|||can; to be able to|Kannst du mir kurz helfen?|Can you help me for a moment?|Ich kann schon ein wenig Deutsch sprechen.|I can speak a little German already.
müssen|verb|||must; to have to|Ich muss morgen früh aufstehen.|I have to get up early tomorrow.|Müssen wir hier umsteigen?|Do we have to change here?
dürfen|verb|||may; to be allowed to|Darf ich mich hier hinsetzen?|May I sit here?|Hier darf man nicht parken.|Parking is not allowed here.
wollen|verb|||to want|Wir wollen am Wochenende wandern.|We want to go hiking at the weekend.|Was willst du heute kochen?|What do you want to cook today?
sollen|verb|||should; to be supposed to|Soll ich dir einen Kaffee machen?|Shall I make you a coffee?|Wir sollen um neun da sein.|We are supposed to be there at nine.
sein|verb|||to be|Ich bin heute sehr glücklich.|I am very happy today.|Wir sind gleich da.|We will be there soon.
haben|verb|||to have|Hast du einen Moment Zeit?|Do you have a moment?|Wir haben einen kleinen Garten.|We have a small garden.
werden|verb|||to become|Die Tage werden wieder länger.|The days are getting longer again.|Ich möchte Ärztin werden.|I would like to become a doctor.
lassen|verb|||to let; to leave|Lass das Fenster bitte offen.|Please leave the window open.|Ich lasse mein Fahrrad reparieren.|I am having my bicycle repaired.
halten|verb|||to hold; to stop|Kannst du kurz meine Tasche halten?|Can you hold my bag for a moment?|Der Zug hält in jeder kleinen Stadt.|The train stops in every small town.
bringen|verb|||to bring|Ich bringe frisches Brot mit.|I will bring fresh bread.|Kannst du mir ein Glas Wasser bringen?|Can you bring me a glass of water?
holen|verb|||to fetch; to get|Ich hole die Kinder von der Schule ab.|I pick up the children from school.|Hol dir eine warme Jacke.|Get yourself a warm jacket.
schicken|verb|||to send|Ich schicke dir die Adresse.|I will send you the address.|Kannst du mir das Foto schicken?|Can you send me the photo?
zeigen|verb|||to show|Kannst du mir den Weg zeigen?|Can you show me the way?|Ich zeige dir meinen Lieblingsplatz.|I will show you my favorite place.
legen|verb|||to put; to lay|Leg das Buch bitte auf den Tisch.|Please put the book on the table.|Ich lege den Schlüssel neben die Tür.|I put the key next to the door.
stellen|verb|||to put upright; to place|Stell die Flasche bitte in den Kühlschrank.|Please put the bottle in the fridge.|Wir stellen die Stühle auf den Balkon.|We put the chairs on the balcony.
sitzen|verb|||to sit|Wir sitzen draußen in der Sonne.|We are sitting outside in the sun.|Neben mir sitzt ein guter Freund.|A good friend is sitting next to me.
stehen|verb|||to stand|Der Bus steht an der Haltestelle.|The bus is at the stop.|Die Blumen stehen auf dem Tisch.|The flowers are on the table.
liegen|verb|||to lie; to be situated|Mein Handy liegt unter dem Buch.|My phone is under the book.|Das Dorf liegt am See.|The village is situated by the lake.
passen|verb|||to fit; to suit|Die Schuhe passen mir gut.|The shoes fit me well.|Passt dir morgen um zehn?|Does ten tomorrow suit you?
fehlen|verb|||to be missing; to lack|In der Suppe fehlt noch Salz.|The soup still needs salt.|Du fehlst mir.|I miss you.
kosten|verb|||to cost|Wie viel kostet das Brot?|How much does the bread cost?|Die Fahrkarte kostet drei Euro.|The ticket costs three euros.
dauern|verb|||to take time; to last|Wie lange dauert die Fahrt?|How long does the journey take?|Die Pause dauert fünfzehn Minuten.|The break lasts fifteen minutes.
gehören|verb|||to belong|Wem gehört diese Tasche?|Who does this bag belong to?|Fehler gehören zum Lernen dazu.|Mistakes are part of learning.
glauben|verb|||to believe; to think|Ich glaube, der Bus kommt gleich.|I think the bus is coming soon.|Glaubst du, dass es morgen regnet?|Do you think it will rain tomorrow?
ändern|verb|||to change; to alter|Wir ändern unseren Plan.|We are changing our plan.|Das Wetter ändert sich schnell.|The weather changes quickly.
entscheiden|verb|||to decide|Wir entscheiden morgen über die Reise.|We will decide about the trip tomorrow.|Ich kann mich noch nicht entscheiden.|I cannot decide yet.
entschuldigen|verb|||to excuse; to apologize|Entschuldigen Sie bitte die Verspätung.|Please excuse the delay.|Ich möchte mich bei dir entschuldigen.|I would like to apologize to you.
erzählen|verb|||to tell; to recount|Erzähl mir von deinem Tag.|Tell me about your day.|Meine Großmutter erzählt gern Geschichten.|My grandmother likes telling stories.
erreichen|verb|||to reach|Wir erreichen den Bahnhof rechtzeitig.|We will reach the station in time.|Unter dieser Nummer kannst du mich erreichen.|You can reach me at this number.
bequem|adjective|||comfortable|Diese Schuhe sind sehr bequem.|These shoes are very comfortable.|Mach es dir bequem.|Make yourself comfortable.
gemütlich|adjective|||cozy|Das Café ist klein und gemütlich.|The café is small and cozy.|Wir machen es uns zu Hause gemütlich.|We make ourselves cozy at home.
hell|adjective|||bright; light|Die Wohnung ist auch im Winter hell.|The apartment is bright even in winter.|Ich trage heute ein helles Hemd.|I am wearing a light-colored shirt today.
dunkel|adjective|||dark|Im Winter wird es früh dunkel.|It gets dark early in winter.|Der Himmel ist heute sehr dunkel.|The sky is very dark today.
sauber|adjective|||clean|Die Küche ist wieder sauber.|The kitchen is clean again.|Bitte hinterlasse den Platz sauber.|Please leave the space clean.
schmutzig|adjective|||dirty|Nach der Wanderung sind meine Schuhe schmutzig.|My shoes are dirty after the hike.|Das Fenster ist vom Regen schmutzig.|The window is dirty from the rain.
trocken|adjective|||dry|Die Jacke ist endlich trocken.|The jacket is finally dry.|Morgen soll es trocken bleiben.|It is supposed to stay dry tomorrow.
nass|adjective|||wet|Meine Schuhe sind vom Regen nass.|My shoes are wet from the rain.|Vorsicht, der Boden ist nass.|Careful, the floor is wet.
spannend|adjective|||exciting; gripping|Das Buch ist so spannend, dass ich weiterlesen möchte.|The book is so gripping that I want to keep reading.|Ein neues Land zu entdecken ist spannend.|Discovering a new country is exciting.
langweilig|adjective|||boring|Der Film war mir zu langweilig.|The film was too boring for me.|Mit dir wird es nie langweilig.|It never gets boring with you.
einfach|adjective|||simple; easy|Dieses Rezept ist ganz einfach.|This recipe is very simple.|Mit einem Beispiel ist es einfacher.|It is easier with an example.
schwierig|adjective|||difficult|Die Aufgabe ist schwierig, aber machbar.|The task is difficult but manageable.|Manchmal ist der erste Schritt schwierig.|Sometimes the first step is difficult.
möglich|adjective|||possible|Ist ein früherer Termin möglich?|Is an earlier appointment possible?|Mit Geduld ist vieles möglich.|Many things are possible with patience.
fertig|adjective|||finished; ready|Bist du mit der Arbeit fertig?|Have you finished your work?|Das Essen ist fertig.|The food is ready.
bereit|adjective|||ready; prepared|Ich bin bereit für den nächsten Schritt.|I am ready for the next step.|Bist du bereit, loszufahren?|Are you ready to set off?
sicher|adjective|||safe; sure|Bist du sicher, dass der Zug hier hält?|Are you sure the train stops here?|Hier fühle ich mich sicher.|I feel safe here.
gleich|adverb|||soon; right away|Ich bin gleich wieder da.|I will be right back.|Der Film beginnt gleich.|The film is about to start.
zuerst|adverb|||first; first of all|Zuerst trinken wir einen Kaffee.|First we will have a coffee.|Was möchtest du zuerst machen?|What would you like to do first?
danach|adverb|||afterward|Wir essen zusammen und gehen danach spazieren.|We eat together and go for a walk afterward.|Danach habe ich Zeit für dich.|Afterward I have time for you.
deshalb|adverb|||therefore; that is why|Es regnet, deshalb bleiben wir drinnen.|It is raining; that is why we are staying inside.|Ich lerne Deutsch, deshalb übe ich jeden Tag.|I am learning German; that is why I practice every day.
trotzdem|adverb|||nevertheless; anyway|Es regnet, aber wir gehen trotzdem spazieren.|It is raining, but we are going for a walk anyway.|Ich bin müde, trotzdem lese ich noch eine Seite.|I am tired; nevertheless I read another page.
besonders|adverb|||especially|Dieses Brot schmeckt besonders gut.|This bread tastes especially good.|Ich freue mich besonders auf den Frühling.|I am especially looking forward to spring.
fast|adverb|||almost|Wir sind fast am Bahnhof.|We are almost at the station.|Der Kuchen ist fast fertig.|The cake is almost ready.
genug|adverb|||enough|Haben wir genug Zeit?|Do we have enough time?|Für alle ist genug Suppe da.|There is enough soup for everyone.
wenig|adjective|||little; few|Heute habe ich wenig Zeit.|Today I have little time.|Für das Rezept brauchen wir nur wenig Salz.|We need only a little salt for the recipe.
viel|adjective|||much; many; a lot|Vielen Dank für deine Hilfe.|Thank you very much for your help.|Ich habe heute viel gelernt.|I have learned a lot today.
mehr|adverb|||more|Möchtest du noch mehr Tee?|Would you like some more tea?|Ich möchte mehr über die Stadt erfahren.|I would like to learn more about the city.
weniger|adverb|||less; fewer|Heute ist weniger Verkehr als gestern.|There is less traffic today than yesterday.|Ich möchte weniger Zeit am Handy verbringen.|I want to spend less time on my phone.
alles|pronoun|||everything|Ist alles in Ordnung?|Is everything all right?|Ich habe alles für die Reise gepackt.|I have packed everything for the trip.
etwas|pronoun|||something; a little|Möchtest du etwas trinken?|Would you like something to drink?|Ich brauche noch etwas Zeit.|I still need a little time.
nichts|pronoun|||nothing|Ich habe heute noch nichts gegessen.|I have not eaten anything today yet.|Das macht nichts.|That does not matter.
jemand|pronoun|||someone|Ist jemand zu Hause?|Is anyone at home?|Jemand hat seine Tasche vergessen.|Someone has forgotten their bag.
niemand|pronoun|||nobody; no one|Heute ist niemand im Büro.|Nobody is in the office today.|Niemand muss alles sofort verstehen.|Nobody has to understand everything right away.
jeder|pronoun|||every; each|Jeder Tag ist eine neue Möglichkeit.|Every day is a new opportunity.|Hier bekommt jeder ein Glas Wasser.|Everyone gets a glass of water here.
beide|pronoun|||both|Wir haben beide morgen frei.|We both have tomorrow off.|Beide Antworten sind möglich.|Both answers are possible.
erster|adjective|||first|Das ist mein erster Tag im neuen Kurs.|This is my first day in the new course.|Der erste Schritt ist oft der schwerste.|The first step is often the hardest.
letzter|adjective|||last|Ich nehme den letzten Bus.|I am taking the last bus.|Letzte Woche war ich krank.|I was ill last week.
nächster|adjective|||next|An der nächsten Haltestelle steigen wir aus.|We get off at the next stop.|Nächste Woche beginnt mein Urlaub.|My vacation starts next week.
anderer|adjective|||other; another|Heute nehmen wir einen anderen Weg.|Today we take a different route.|Hast du noch eine andere Idee?|Do you have another idea?
eigen|adjective|||own|Ich möchte meine eigene Wohnung haben.|I would like to have my own apartment.|Jeder lernt in seinem eigenen Tempo.|Everyone learns at their own pace.
gemeinsam|adjective|||shared; together|Wir haben ein gemeinsames Ziel.|We have a shared goal.|Gemeinsam finden wir eine Lösung.|Together we will find a solution.
Lösung|noun|die|Lösungen|solution|Für dieses Problem finden wir eine Lösung.|We will find a solution to this problem.|Die Lösung ist einfacher als gedacht.|The solution is simpler than expected.
Problem|noun|das|Probleme|problem|Ich habe ein Problem mit meinem Fahrrad.|I have a problem with my bicycle.|Das ist kein großes Problem.|That is not a big problem.
Ordnung|noun|die|Ordnungen|order; tidiness|Ist bei dir alles in Ordnung?|Is everything all right with you?|Ich bringe Ordnung in meine Unterlagen.|I put my documents in order.
Ruhe|noun|die|—|peace; quiet|Morgens genieße ich die Ruhe.|I enjoy the quiet in the morning.|Lass uns das in Ruhe besprechen.|Let us discuss that calmly.
Spaß|noun|der|Späße|fun|Deutsch lernen macht mir Spaß.|Learning German is fun for me.|Viel Spaß bei deinem Ausflug!|Have fun on your outing!
Lust|noun|die|—|desire; inclination|Hast du Lust auf einen Spaziergang?|Do you feel like going for a walk?|Heute habe ich Lust zu kochen.|Today I feel like cooking.
Hoffnung|noun|die|Hoffnungen|hope|Ich habe Hoffnung auf besseres Wetter.|I have hope for better weather.|Diese Nachricht gibt uns Hoffnung.|This news gives us hope.
Erfahrung|noun|die|Erfahrungen|experience|Die Reise war eine schöne Erfahrung.|The trip was a lovely experience.|Hast du Erfahrung mit dieser Arbeit?|Do you have experience with this work?
Erinnerung|noun|die|Erinnerungen|memory; reminder|An diesen Tag habe ich eine schöne Erinnerung.|I have a lovely memory of that day.|Das Foto weckt viele Erinnerungen.|The photo brings back many memories.
Augenblick|noun|der|Augenblicke|moment|Warte bitte einen Augenblick.|Please wait a moment.|Genießen wir diesen ruhigen Augenblick.|Let us enjoy this quiet moment.
Zukunft|noun|die|—|future|Ich freue mich auf die Zukunft.|I am looking forward to the future.|In Zukunft möchte ich öfter Deutsch sprechen.|In the future I would like to speak German more often.
Vergangenheit|noun|die|—|past|Diese Geschichte spielt in der Vergangenheit.|This story is set in the past.|Wir sprechen über die Vergangenheit der Stadt.|We talk about the city’s past.
Gegenwart|noun|die|—|present; presence|Ich möchte die Gegenwart bewusster erleben.|I would like to experience the present more consciously.|In deiner Gegenwart fühle ich mich wohl.|I feel comfortable in your presence.
Natur|noun|die|—|nature|Am Wochenende verbringe ich gern Zeit in der Natur.|I like spending time in nature at the weekend.|Die Natur erwacht im Frühling.|Nature awakens in spring.
Frühling|noun|der|Frühlinge|spring|Im Frühling werden die Tage länger.|The days get longer in spring.|Ich freue mich auf den Frühling.|I am looking forward to spring.
Sommer|noun|der|Sommer|summer|Im Sommer essen wir oft draußen.|We often eat outside in summer.|Dieser Sommer ist besonders warm.|This summer is especially warm.
Herbst|noun|der|Herbste|autumn; fall|Im Herbst färben sich die Blätter.|The leaves change color in autumn.|Wir wandern gern im Herbst.|We like hiking in autumn.
Winter|noun|der|Winter|winter|Im Winter trinke ich gern heißen Tee.|I like drinking hot tea in winter.|Letzten Winter lag viel Schnee.|There was a lot of snow last winter.
Himmel|noun|der|Himmel|sky; heaven|Am Himmel sind heute viele Wolken.|There are many clouds in the sky today.|Der Himmel über dem See ist klar.|The sky above the lake is clear.
Wolke|noun|die|Wolken|cloud|Eine dunkle Wolke zieht auf.|A dark cloud is approaching.|Zwischen den Wolken scheint die Sonne.|The sun shines between the clouds.
Luft|noun|die|Lüfte|air|Ich brauche ein bisschen frische Luft.|I need a little fresh air.|Die Luft riecht nach Regen.|The air smells of rain.
Blatt|noun|das|Blätter|leaf; sheet of paper|Ein Blatt fällt vom Baum.|A leaf falls from the tree.|Hast du ein Blatt Papier für mich?|Do you have a sheet of paper for me?
Wurzel|noun|die|Wurzeln|root|Die Wurzeln des Baums reichen tief.|The tree’s roots reach deep.|Die Pflanze braucht Platz für ihre Wurzeln.|The plant needs room for its roots.
wachsen|verb|||to grow|Die Pflanzen wachsen am Fenster.|The plants grow by the window.|Mit jedem Tag wächst mein Wortschatz.|My vocabulary grows with every day.
blühen|verb|||to bloom|Die Blumen im Garten blühen schon.|The flowers in the garden are blooming already.|Im Frühling blühen die Apfelbäume.|The apple trees bloom in spring.
gießen|verb|||to water; to pour|Ich gieße jeden Morgen die Blumen.|I water the flowers every morning.|Gieß bitte etwas Wasser in die Schale.|Please pour some water into the bowl.
pflegen|verb|||to care for; to maintain|Meine Nachbarin pflegt ihren Garten.|My neighbor takes care of her garden.|Eine gute Freundschaft muss man pflegen.|A good friendship needs to be nurtured.
entdecken|verb|||to discover|Auf der Reise entdecken wir neue Orte.|We discover new places on the trip.|Ich habe ein schönes Café entdeckt.|I discovered a lovely café.
genießen|verb|||to enjoy; to savor|Ich genieße die Ruhe am Morgen.|I enjoy the quiet in the morning.|Genieß deinen Urlaub!|Enjoy your vacation!
lächeln|verb|||to smile|Sie lächelt mich freundlich an.|She smiles at me warmly.|Beim Lesen der Nachricht muss ich lächeln.|Reading the message makes me smile.
lachen|verb|||to laugh|Wir lachen viel zusammen.|We laugh a lot together.|Über diese Geschichte muss ich immer lachen.|That story always makes me laugh.
träumen|verb|||to dream|Ich träume von einer Reise ans Meer.|I dream of a trip to the sea.|Letzte Nacht habe ich von unserem Garten geträumt.|Last night I dreamed about our garden.
Wortschatz|noun|der|Wortschätze|vocabulary|Mein Wortschatz wächst jeden Tag.|My vocabulary grows every day.|Ein großer Wortschatz braucht viele kleine Schritte.|A large vocabulary takes many small steps.
Tempo|noun|das|Tempi|pace; speed|Ich lerne in meinem eigenen Tempo.|I learn at my own pace.|Wir können das Tempo etwas langsamer machen.|We can slow the pace down a little.
Schritt|noun|der|Schritte|step|Jeder kleine Schritt zählt.|Every small step counts.|Wir gehen Schritt für Schritt vor.|We proceed step by step.
Welt|noun|die|Welten|world|Eine neue Sprache zeigt mir eine neue Welt.|A new language shows me a new world.|Die Welt ist voller Geschichten.|The world is full of stories.
""".strip()


def build():
    words = []
    for rank, row in enumerate(ROWS.splitlines(), 1):
        german, kind, article, plural, meaning, de1, en1, de2, en2 = row.split('|')
        identity = hashlib.sha256(f'{kind}:{german}'.encode()).hexdigest()[:12]
        word = dict(id=f'de-{identity}', german=german, type=kind, rank=rank,
                    answerKey=german.casefold(),
                    translations=[dict(language='en', meaning=meaning, answerKey=meaning.casefold())],
                    examples=[dict(german=de1, translations=dict(en=en1)),
                              dict(german=de2, translations=dict(en=en2))])
        if article:
            word.update(article=article, plural=plural)
        # Explicit sense-equivalence groups, reviewed alongside distractors.
        equivalents = {'beginnen': 'begin', 'Anfang': 'beginning',
                       'schwierig': 'difficult', 'schwer': 'difficult',
                       'einfach': 'easy', 'leicht': 'easy',
                       'Freund': 'friend', 'Freundin': 'friend',
                       'Arzt': 'doctor', 'Ärztin': 'doctor',
                       'Nachbar': 'neighbor', 'Nachbarin': 'neighbor',
                       'bereit': 'ready', 'fertig': 'ready',
                       'Weg': 'way', 'Straße': 'way'}
        if german in equivalents:
            word['translations'][0]['answerKey'] = equivalents[german]
        words.append(word)
    corpus = dict(version='0.1.0-draft.1', language='de', translationLanguages=['en'],
                  editorialStatus='unreviewed', words=words)
    target = ROOT / 'assets/content/vocabulary.json'
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(corpus, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Wrote {len(words)} original draft records to {target}')


if __name__ == '__main__':
    build()
