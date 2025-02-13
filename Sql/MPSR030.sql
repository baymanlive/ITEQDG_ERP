


alter procedure proc_MPSR030
@bu varchar(10)='ITEQDG',@filter nvarchar(max)=''
as
	if @filter=''
		set @filter='and sdate>''2025/1/1'''
	declare @sql varchar(max)
	declare @sfb table(sfb01 varchar(10),sfb09 dec(15,3))
	declare @mps table(custno2 varchar(100),custname2 varchar(100),machine nvarchar(10),sdate datetime,currentboiler numeric(2,0),wono varchar(10),orderdate datetime,orderno varchar(10),orderitem int,materialno varchar(20),sqty numeric(15,3),adate_new datetime,custno varchar(10),custom varchar(40),custom2 varchar(40),stealno varchar(5),premark varchar(30),premark2 varchar(30),premark3 varchar(30),orderqty numeric(15,3),orderno2 varchar(10),orderitem2 int,materialno1 varchar(20),pnlsize1 numeric(10,2),pnlsize2 numeric(10,2),edate datetime,adhesive varchar(20),thickness varchar(10),copper varchar(10),supplier varchar(10),sizes varchar(10),oz varchar(10),simuver nvarchar(11),citem int,jitem int,errorflag numeric(1,0),remain_ordqty float,struct varchar(200)) 

	set @sql='select sfb01,sfb09 from openquery(ITEQDG,''select sfb01,sfb09 from sfb_file where (sfb25>=add_months(sysdate,-6)) and sfb04 in (''''6'''',''''7'''',''''8'''')'')'
	insert into @sfb exec(@sql)
	select * from @sfb


	set @sql=	'select custno2,custname2,machine,sdate,currentboiler,wono,orderdate,orderno,orderitem,
				materialno,sqty,adate_new,custno,custom,custom2,stealno,premark,premark2,premark3,
				orderqty,orderno2,orderitem2,materialno1,pnlsize1,pnlsize2,edate,adhesive,thickness,
				copper,supplier,sizes,oz,simuver,citem,jitem,errorflag,remain_ordqty,struct into #mps010
				from mps010 where bu=''ITEQDG'' and case_ans2=1 and isnull(errorflag,0)=0 '+@filter   
	insert into @mps exec(@sql)
	select * from @mps
	select a.*,sfb09 from @mps a left join @sfb on wono=sfb01		