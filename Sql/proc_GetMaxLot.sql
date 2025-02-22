USE [ERP2015]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetMaxLot]    Script Date: 11/25/2024 8:52:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		kaikai
-- Create date: 2016/11/24
-- Description:	客戶最新出貨批號
-- =============================================
ALTER PROCEDURE [dbo].[proc_GetMaxLot]
(
	@bu varchar(6),							--營運中心
	@custno varchar(10),					--客戶編號
	@pno varchar(30),						--料號
	@longitude varchar(30) = '',			--經向
	@latitude varchar(30)  = '',			--緯向
	@exceptindate varchar(10) = ''			--排除此出貨日期
)
AS
	if @bu='AA' --測試
	begin
		select '' as manfac
		return
	end
	
	declare @tmppno varchar(30)
	declare @manfac varchar(20)
	declare @indate varchar(10)
	declare @code2 varchar(1)
	declare @lstcode varchar(1)
	declare @ftype int
	declare @old_ch varchar(20)
	declare @new_ch varchar(20)
	set @old_ch='0123456789'
	set @new_ch='ABCDE56789' --批號第2碼跨10年0>9,2024年需要重新修改

	if len(@bu)=0 or len(@custno)=0 or len(@pno)<10
	begin
		select '' as manfac
		return
	end

	if len(@exceptindate)=0
		set @indate='1955-5-5'
	else
		set @indate=@exceptindate

	--@ftype=1,2,3,4 即第2碼+尾碼表示不同的物料
	set @code2=upper(right(left(@pno,2),1))
	set @lstcode=upper(right(@pno,1))
	if @code2='O' and @lstcode in ('S','N')
		set @ftype=1
	else if @code2='O' and @lstcode in ('X','G','R')
		set @ftype=2
	else if @code2='U' and @lstcode in ('X','G','5','R','C','E')
		set @ftype=3
	else if @code2='U' and @lstcode in ('3','Z','I','H','F','B')
		set @ftype=4
	else
		set @ftype=0

	if @custno in ('AC121','AC305','AC526','ACA97','AC820')	--崇達集團去尾碼、其它去首碼+尾碼
		set @tmppno=substring(@pno,1,len(@pno)-1)
	else
		set @tmppno=substring(@pno,2,len(@pno)-2)
							
	if @ftype=0
	begin			
		if len(@pno) in (11,12) and len(@longitude)>0 and len(@latitude)>0
			select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
			on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
			where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%')  and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
			and a.longitude=@longitude and a.latitude=@latitude
			and substring(a.pno,2,1)+right(a.pno,1) not in ('OS','ON','OX','OG','OR','UX','UG','U5','UR','UC','UE','U3','UZ','UI','UH','UF','UB')
			and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
			order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
		else
			select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
			on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
			where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
			and substring(a.pno,2,1)+right(a.pno,1) not in ('OS','ON','OX','OG','OR','UX','UG','U5','UR','UC','UE','U3','UZ','UI','UH','UF','UB')
			and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
			order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
	end else
	begin			
		if @ftype=1
		begin 
			if len(@pno) in (11,12) and len(@longitude)>0 and len(@latitude)>0
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and a.longitude=@longitude and a.latitude=@latitude 
				and substring(a.pno,2,1)+right(a.pno,1) in ('OS','ON')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
			else
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and substring(a.pno,2,1)+right(a.pno,1) in ('OS','ON')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
		end
		else if @ftype=2
		begin 
			if len(@pno) in (11,12) and len(@longitude)>0 and len(@latitude)>0
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and a.longitude=@longitude and a.latitude=@latitude 
				and substring(a.pno,2,1)+right(a.pno,1) in ('OX','OG','OR')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
			else
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and substring(a.pno,2,1)+right(a.pno,1) in ('OX','OG','OR')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
		end	
		else if @ftype=3
		begin 
			if len(@pno) in (11,12) and len(@longitude)>0 and len(@latitude)>0
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and a.longitude=@longitude and a.latitude=@latitude 
				and substring(a.pno,2,1)+right(a.pno,1) in ('UX','UG','U5','UR','UC','UE')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
			else
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and substring(a.pno,2,1)+right(a.pno,1) in ('UX','UG','U5','UR','UC','UE')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
		end
		else if @ftype=4
		begin 
			if len(@pno) in (11,12) and len(@longitude)>0 and len(@latitude)>0
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and a.longitude=@longitude and a.latitude=@latitude 
				and substring(a.pno,2,1)+right(a.pno,1) in ('U3','UZ','UI','UH','UF','UB')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
			else
				select top 1 @manfac=b.manfac from dli010 a inner join dli040 b 
				on a.dno=b.dno and a.ditem=b.ditem and a.bu=b.bu
				where a.bu=@bu and (a.custno=@custno or a.remark like '%'+@custno+'%') and charindex(@tmppno, a.pno)>0 and indate<>@indate and isnull(a.garbageflag,0)=0
				and substring(a.pno,2,1)+right(a.pno,1) in ('U3','UZ','UI','UH','UF','UB')
				and len(b.manfac)>5 and charindex(substring(b.manfac,2,1),@old_ch)>0
				order by substring(@new_ch,charindex(substring(b.manfac,2,1),@old_ch),1)+substring(b.manfac,3,3) desc, b.manfac desc
		end
	end 
	
	set @manfac=isnull(@manfac,'')
	if len(@manfac)<5
		set @manfac=''
	select @manfac as manfac
