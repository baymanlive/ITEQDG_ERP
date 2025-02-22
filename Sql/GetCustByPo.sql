USE [ERP2015]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetCustByPo]    Script Date: 12/18/2024 8:22:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[proc_GetCustByPo] 
@bu varchar(50),@orderno varchar(100),@item varchar(10),@custno2 varchar(100) out,@custname2 varchar(100) out,@Orderno2 varchar(50)=''
as
	
	--set @bu=SUBSTRING(@bu,2,1)
	--if charindex(@bu,'12345')=0 set @bu='ITEQGZ'
	--	else 
	set @bu='ITEQDG'
	--if @Orderno2<>'' set @bu='ITEQDG'

	declare @sql varchar(max)
	set @sql='select oao06 from oao_file where oao01='''+@orderno+''' and oao03='+@item
	set @sql='select * from openquery('+@bu+','''+replace(@sql,'''','''''')+''')'

	declare @t table (oao06 varchar(100))
	declare @idx int

	insert  @t exec(@sql)
	select  @custno2=oao06 from @t
	
	set @idx=charindex('JX-',@custno2)
	if @idx=0
		return
	set @custno2 = substring(@custno2,@idx+14,255)

    set @idx=charindex('-',@custno2)
	if @idx=0 
		return
	set @custno2 = substring(@custno2,@idx+1,5)
	declare @occ02 varchar(50)
	exec proc_getOCC02 @custno2,@occ02 out
	set @custname2=@occ02
