# AdventureWorks2014-OLTP RFM Analyses

Bu layih? müþt?ril?rin satýn alma davranýþlarýný t?hlil ed?r?k onlarý seqmentl?r? ayýrmaq üçün RFM (Recency, Frequency, Monetary) analizind?n istifad? edir. M?qs?d müþt?ril?ri d?y?rl?rin? gör? qruplaþdýrýb biznes? daha effektiv marketinq strategiyalarý hazýrlamaqda köm?k etm?kdir.

RFM marketinq analizind? istifad? olunan bir üsuldur v? 3 komponentd?n ibar?tdir:

* Recency (R): Müþt?rinin ?n son n? vaxt alýþ etdiyi (n? q?d?r yaxýn tarixd?, bir o q?d?r yaxþý)
* Frequency (F): Müþt?rinin n? q?d?r tez-tez alýþ etdiyi (n? q?d?r çox, bir o q?d?r yaxþý)
* Monetary (M): Müþt?rinin ümumi n? q?d?r x?rcl?diyi (n? q?d?r çox, bir o q?d?r yaxþý)



M?lumat d?sti
Layih?d? istifad? olunan m?lumatlar aþaðýdaký sütunlardan ibar?tdir:

* CustomerID: Müþt?ri unikal identifikatoru
* OrderDate: Sifariþ tarixi
* OrderAmount: Sifariþ m?bl?ði
* OrderID: Sifariþ identifikatoru



Analiz addýmlarý

1. M?lumatlarýn t?mizl?nm?si - null d?y?rl?rin t?mizl?nm?si, tarix formatlarýnýn düz?ldilm?si
2. RFM metrikalarýnýn hesablanmasý:
o H?r müþt?ri üçün ?n son alýþ tarixind?n bugün? q?d?r keç?n gün sayý (Recency)
o H?r müþt?rinin ümumi alýþ sayý (Frequency)
o H?r müþt?rinin ümumi x?rcl?diyi m?bl?ð (Monetary)
3. RFM skorlarýnýn verilm?si - h?r metrikaya 1-5 arasý bal verm?k
4. Müþt?ri seqmentl?rinin yaradýlmasý - skorlara ?sas?n müþt?ril?ri qruplaþdýrmaq

