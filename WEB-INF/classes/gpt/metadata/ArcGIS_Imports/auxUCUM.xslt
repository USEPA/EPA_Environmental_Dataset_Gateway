<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:esri="http://www.esri.com/metadata/" xmlns:res="http://www.w3.org/2005/xpath-functions">

<!-- An XSLT template for displaying metadata in ArcGIS. These XSLT templates display the official unit of measure name in conjunction with the unit of measure code.

     Copyright (c) 2009-2013, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 6/15/2009 avienneau
-->

	<xsl:output method="xml" indent="yes"/>
	<xsl:template name="ucum_units">
		<xsl:param name="unit"/>
		
		<xsl:choose>
			<xsl:when test="($unit = 'Ym')"><xsl:value-of select="$unit"/> (<res:idYotta/>)</xsl:when>
			<xsl:when test="($unit = 'Zm')"><xsl:value-of select="$unit"/> (<res:idZetta/>)</xsl:when>
			<xsl:when test="($unit = 'Em')"><xsl:value-of select="$unit"/> (<res:idExa/>)</xsl:when>
			<xsl:when test="($unit = 'Pm')"><xsl:value-of select="$unit"/> (<res:idPeta/>)</xsl:when>
			<xsl:when test="($unit = 'Tm')"><xsl:value-of select="$unit"/> (<res:idTera/>)</xsl:when>
			<xsl:when test="($unit = 'Gm')"><xsl:value-of select="$unit"/> (<res:idGiga/>)</xsl:when>
			<xsl:when test="($unit = 'Mm')"><xsl:value-of select="$unit"/> (<res:idMega/>)</xsl:when>
			<xsl:when test="($unit = 'km')"><xsl:value-of select="$unit"/> (<res:idKilo/>)</xsl:when>
			<xsl:when test="($unit = 'hm')"><xsl:value-of select="$unit"/> (<res:idHecto/>)</xsl:when>
			<xsl:when test="($unit = 'dam')"><xsl:value-of select="$unit"/> (<res:idDeka/>)</xsl:when>
			<xsl:when test="($unit = 'dm')"><xsl:value-of select="$unit"/> (<res:idDeci/>)</xsl:when>
			<xsl:when test="($unit = 'cm')"><xsl:value-of select="$unit"/> (<res:idCenti/>)</xsl:when>
			<xsl:when test="($unit = 'mm')"><xsl:value-of select="$unit"/> (<res:idMilli/>)</xsl:when>
			<xsl:when test="($unit = 'um')"><xsl:value-of select="$unit"/> (<res:idMicro/>)</xsl:when>
			<xsl:when test="($unit = 'nn')"><xsl:value-of select="$unit"/> (<res:idNano/>)</xsl:when>
			<xsl:when test="($unit = 'pm')"><xsl:value-of select="$unit"/> (<res:idPico/>)</xsl:when>
			<xsl:when test="($unit = 'fm')"><xsl:value-of select="$unit"/> (<res:idFemto/>)</xsl:when>
			<xsl:when test="($unit = 'am')"><xsl:value-of select="$unit"/> (<res:idAtto/>)</xsl:when>
			<xsl:when test="($unit = 'zm')"><xsl:value-of select="$unit"/> (<res:idZepto/>)</xsl:when>
			<xsl:when test="($unit = 'ym')"><xsl:value-of select="$unit"/> (<res:idYocto/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'm')"><xsl:value-of select="$unit"/> (<res:idMeter/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 's')"><xsl:value-of select="$unit"/> (<res:idSecond/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'g')"><xsl:value-of select="$unit"/> (<res:idGram/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'rad')"><xsl:value-of select="$unit"/> (<res:idRadian/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'k')"><xsl:value-of select="$unit"/> (<res:idKelvin/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'c')"><xsl:value-of select="$unit"/> (<res:idCoulomb/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cd')"><xsl:value-of select="$unit"/> (<res:idCandela/>)</xsl:when>
			<xsl:when test="($unit = '10*')"><xsl:value-of select="$unit"/> (<res:idTenArbPowsStar/>)</xsl:when>
			<xsl:when test="($unit = '10^')"><xsl:value-of select="$unit"/> (<res:idTenArbPowsCarat/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pi]')"><xsl:value-of select="$unit"/> (<res:idPi/>)</xsl:when>
			<xsl:when test="($unit = '%')"><xsl:value-of select="$unit"/> (<res:idPercent/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ppth]')"><xsl:value-of select="$unit"/> (<res:idPPTh/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ppm]')"><xsl:value-of select="$unit"/> (<res:idPPM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ppb]')"><xsl:value-of select="$unit"/> (<res:idPPB/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pptr]')"><xsl:value-of select="$unit"/> (<res:idPPTr/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mol')"><xsl:value-of select="$unit"/> (<res:idMole/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'sr')"><xsl:value-of select="$unit"/> (<res:idSteradian/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'hz')"><xsl:value-of select="$unit"/> (<res:idHertz/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'n')"><xsl:value-of select="$unit"/> (<res:idNewton/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'pa') or (esri:strtolower($unit) = 'PAL')"><xsl:value-of select="$unit"/> (<res:idPascal/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'j')"><xsl:value-of select="$unit"/> (<res:idJoule/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'w')"><xsl:value-of select="$unit"/> (<res:idWatt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'a')"><xsl:value-of select="$unit"/> (<res:idAmp/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'v')"><xsl:value-of select="$unit"/> (<res:idVolt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'f')"><xsl:value-of select="$unit"/> (<res:idFarad/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ohm')"><xsl:value-of select="$unit"/> <res:idOhm/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 's') or (esri:strtolower($unit) = 'sie')"><xsl:value-of select="$unit"/> (<res:idSiemens/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'wb')"><xsl:value-of select="$unit"/> (<res:idWeber/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cel')"><xsl:value-of select="$unit"/> (<res:idDegCelsius/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 't')"><xsl:value-of select="$unit"/> (<res:idTesla/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'h')"><xsl:value-of select="$unit"/> (<res:idHenry/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'lm')"><xsl:value-of select="$unit"/> (<res:idLumen/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'lx')"><xsl:value-of select="$unit"/> (<res:idLux/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'bq')"><xsl:value-of select="$unit"/> (<res:idBecquerel/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'gy')"><xsl:value-of select="$unit"/> (<res:idGray/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'sv')"><xsl:value-of select="$unit"/> (<res:idSievert/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'gon')"><xsl:value-of select="$unit"/> (<res:idGonGrade/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'deg')"><xsl:value-of select="$unit"/> (<res:idDegree/>)</xsl:when>
			<xsl:when test='($unit = "&apos;")'><xsl:value-of select="$unit"/> (<res:idMinute/>)</xsl:when>
			<xsl:when test="($unit = '&quot;')"><xsl:value-of select="$unit"/> (<res:idSecond_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'l')"><xsl:value-of select="$unit"/> (<res:idLiter/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ar')"><xsl:value-of select="$unit"/> (<res:idAre/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'min')"><xsl:value-of select="$unit"/> (<res:idMinute_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'h')"><xsl:value-of select="$unit"/> (<res:idHour/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'd')"><xsl:value-of select="$unit"/> (<res:idDay/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'a_t') or (esri:strtolower($unit) = 'ann_t')"><xsl:value-of select="$unit"/> (<res:idTropicalYear/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'a_j') or (esri:strtolower($unit) = 'ann_j')"><xsl:value-of select="$unit"/> (<res:idMeanJulianYear/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'a_g') or (esri:strtolower($unit) = 'ann_g')"><xsl:value-of select="$unit"/> (<res:idMeanGregorianYear/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'a') or (esri:strtolower($unit) = 'ann')"><xsl:value-of select="$unit"/> (<res:idYear/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'wk')"><xsl:value-of select="$unit"/> (<res:idWeek/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mo_s')"><xsl:value-of select="$unit"/> (<res:idSynodalMonth/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mo_j')"><xsl:value-of select="$unit"/> (<res:idMeanJulianMonth/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mo_g')"><xsl:value-of select="$unit"/> (<res:idMeanGregorianMonth/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mo')"><xsl:value-of select="$unit"/> (<res:idMonth/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 't') or (esri:strtolower($unit) = 'tne')"><xsl:value-of select="$unit"/> (<res:idTonne/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'bar')"><xsl:value-of select="$unit"/> (<res:idBar/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'u') or (esri:strtolower($unit) = 'amu')"><xsl:value-of select="$unit"/> (<res:idAMU/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ev')"><xsl:value-of select="$unit"/> (<res:idEV/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'au') or (esri:strtolower($unit) = 'asu')"><xsl:value-of select="$unit"/> (<res:idAU/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'pc') or (esri:strtolower($unit) = 'prs')"><xsl:value-of select="$unit"/> (<res:idParsec/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[c]')"><xsl:value-of select="$unit"/> (<res:idVelocityOfLight/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[h]')"><xsl:value-of select="$unit"/> (<res:idPlanckConstant/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[k]')"><xsl:value-of select="$unit"/> (<res:idBoltzmannConstant/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[eps_0]')"><xsl:value-of select="$unit"/> (<res:idPermittivityOfVacuum/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mu_0]')"><xsl:value-of select="$unit"/> (<res:idPermeabilityOfVacuum/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[e]')"><xsl:value-of select="$unit"/> (<res:idElementaryCharge/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[m_e]')"><xsl:value-of select="$unit"/> (<res:idElectronMass/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[m_p]')"><xsl:value-of select="$unit"/> (<res:idProtonMass/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[g]') or (esri:strtolower($unit) = '[gc]')"><xsl:value-of select="$unit"/> (<res:idNewtonGravConstant/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[g]')"><xsl:value-of select="$unit"/> (<res:idStdFreefallAccel/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'atm')"><xsl:value-of select="$unit"/> (<res:idStdAtmo/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ly]')"><xsl:value-of select="$unit"/> (<res:idLightyear/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'gf')"><xsl:value-of select="$unit"/> (<res:idGramForce/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lbf_av]')"><xsl:value-of select="$unit"/> (<res:idPoundForce/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ky')"><xsl:value-of select="$unit"/> (<res:idKayser/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'gal') or (esri:strtolower($unit) = 'gl')"><xsl:value-of select="$unit"/> (<res:idGal/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'dyn')"><xsl:value-of select="$unit"/> (<res:idDyne/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'erg')"><xsl:value-of select="$unit"/> (<res:idErg/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'p')"><xsl:value-of select="$unit"/> (<res:idPoise/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'bi')"><xsl:value-of select="$unit"/> (<res:idBiot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'st')"><xsl:value-of select="$unit"/> (<res:idStokes/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mx')"><xsl:value-of select="$unit"/> (<res:idMaxwell/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'g') or (esri:strtolower($unit) = 'gs')"><xsl:value-of select="$unit"/> (<res:idGauss/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'oe')"><xsl:value-of select="$unit"/> (<res:idOersted/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'gb')"><xsl:value-of select="$unit"/> (<res:idGilbert/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'sb')"><xsl:value-of select="$unit"/> (<res:idStilb/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'lmb')"><xsl:value-of select="$unit"/> (<res:idLambert/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ph') or (esri:strtolower($unit) = 'pht')"><xsl:value-of select="$unit"/> (<res:idPhot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ci')"><xsl:value-of select="$unit"/> (<res:idCurie/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'r') or (esri:strtolower($unit) = 'roe')"><xsl:value-of select="$unit"/> (<res:idRoentgen/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'rad') or (esri:strtolower($unit) = '[rad]')"><xsl:value-of select="$unit"/> (<res:idRadiationAbsorbedDose/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'rem') or (esri:strtolower($unit) = '[rem]')"><xsl:value-of select="$unit"/> (<res:idRadiationEquivalentMan/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[in_i]')"><xsl:value-of select="$unit"/> (<res:idInch/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ft_i]')"><xsl:value-of select="$unit"/> (<res:idFoot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[yd_i]')"><xsl:value-of select="$unit"/> (<res:idYard/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mi_i]')"><xsl:value-of select="$unit"/> (<res:idStatuteMile/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[fth_i]')"><xsl:value-of select="$unit"/> (<res:idFathom/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[nmi_i]')"><xsl:value-of select="$unit"/> (<res:idNauticalMile/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[kn_i]')"><xsl:value-of select="$unit"/> (<res:idKnot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[sin_i]')"><xsl:value-of select="$unit"/> (<res:idSquareInch/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[sft_i]')"><xsl:value-of select="$unit"/> (<res:idSquareFoot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[syd_i]')"><xsl:value-of select="$unit"/> (<res:idSquareYard/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cin_i]')"><xsl:value-of select="$unit"/> (<res:idCubicInch/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cft_i]')"><xsl:value-of select="$unit"/> (<res:idCubicFoot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cyd_i]')"><xsl:value-of select="$unit"/> (<res:idCubicYard/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[bf_i]')"><xsl:value-of select="$unit"/> (<res:idBoardFoot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cr_i]')"><xsl:value-of select="$unit"/> (<res:idCord/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mil_i]')"><xsl:value-of select="$unit"/> (<res:idMil/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cml_i]')"><xsl:value-of select="$unit"/> (<res:idCircularMil/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[hd_i]')"><xsl:value-of select="$unit"/> (<res:idHand/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ft_us]')"><xsl:value-of select="$unit"/> (<res:idFoot_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[yd_us]')"><xsl:value-of select="$unit"/> (<res:idYard_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[in_us]')"><xsl:value-of select="$unit"/> (<res:idInch_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[rd_us]')"><xsl:value-of select="$unit"/> (<res:idRod/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ch_us]')"><xsl:value-of select="$unit"/> (<res:idGunterSurveyorChain/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lk_us]')"><xsl:value-of select="$unit"/> (<res:idGunterChainLink/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[rch_us]')"><xsl:value-of select="$unit"/> (<res:idRamdenEngineerChain/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[rlk_us]')"><xsl:value-of select="$unit"/> (<res:idRamdenChainLink/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[fth_us]')"><xsl:value-of select="$unit"/> (<res:idFathom_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[fur_us]')"><xsl:value-of select="$unit"/> (<res:idFurlong/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mi_us]')"><xsl:value-of select="$unit"/> <res:idMile/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[acr_us]')"><xsl:value-of select="$unit"/> (<res:idAcre/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[srd_us]')"><xsl:value-of select="$unit"/> (<res:idSquareRod/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[smi_us]')"><xsl:value-of select="$unit"/> (<res:idSquareMile/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[sct]')"><xsl:value-of select="$unit"/> (<res:idSection/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[twp]')"><xsl:value-of select="$unit"/> (<res:idTownship/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mil_us]')"><xsl:value-of select="$unit"/> (<res:idMil_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[in_br]')"><xsl:value-of select="$unit"/> (<res:idInch_auxUCUM_0/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ft_br]')"><xsl:value-of select="$unit"/> (<res:idFoot_auxUCUM_0/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[rd_br]')"><xsl:value-of select="$unit"/> (<res:idRod_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ch_br]')"><xsl:value-of select="$unit"/> (<res:idGunterChain/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lk_br]')"><xsl:value-of select="$unit"/> (<res:idGunterChainLink_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[fth_br]')"><xsl:value-of select="$unit"/> (<res:idFathom_auxUCUM_0/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pc_br]')"><xsl:value-of select="$unit"/> (<res:idPace/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[yd_br]')"><xsl:value-of select="$unit"/> (<res:idYard_auxUCUM_0/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mi_br]')"><xsl:value-of select="$unit"/> (<res:idMile_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[nmi_br]')"><xsl:value-of select="$unit"/> (<res:idNauticalMile_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[kn_br]')"><xsl:value-of select="$unit"/> (<res:idKnot_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[acr_br]')"><xsl:value-of select="$unit"/> (<res:idAcre_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[gal_us]')"><xsl:value-of select="$unit"/> (<res:idQueenAnneWineGallon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[bbl_us]')"><xsl:value-of select="$unit"/> (<res:idBarrel/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[qt_us]')"><xsl:value-of select="$unit"/> (<res:idQuart/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pt_us]')"><xsl:value-of select="$unit"/> (<res:idPint/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[gil_us]')"><xsl:value-of select="$unit"/> (<res:idGill/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[foz_us]')"><xsl:value-of select="$unit"/> (<res:idFluidOunce/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[fdr_us]')"><xsl:value-of select="$unit"/> (<res:idFluidDram/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[min_us]')"><xsl:value-of select="$unit"/> (<res:idMinim/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[crd_us]')"><xsl:value-of select="$unit"/> (<res:idCord_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[bu_us]')"><xsl:value-of select="$unit"/> (<res:idBushel/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[gal_wi]')"><xsl:value-of select="$unit"/> (<res:idHistWinchesterGallon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pk_us]')"><xsl:value-of select="$unit"/> (<res:idPeck/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[dqt_us]')"><xsl:value-of select="$unit"/> (<res:idDryQuart/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[dpt_us]')"><xsl:value-of select="$unit"/> (<res:idDryPint/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[tbs_us]')"><xsl:value-of select="$unit"/> (<res:idTablespoon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[tsp_us]')"><xsl:value-of select="$unit"/> (<res:idTeaspoon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cup_us]')"><xsl:value-of select="$unit"/> (<res:idCup/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[gal_br]')"><xsl:value-of select="$unit"/> (<res:idGallon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pk_br]')"><xsl:value-of select="$unit"/> (<res:idPeck_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[bu_br]')"><xsl:value-of select="$unit"/> (<res:idBushel_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[qt_br]')"><xsl:value-of select="$unit"/> (<res:idQuart_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pt_br]')"><xsl:value-of select="$unit"/> (<res:idPint_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[gil_br]')"><xsl:value-of select="$unit"/> (<res:idGill_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[foz_br]')"><xsl:value-of select="$unit"/> (<res:idFluidOunce_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[fdr_br]')"><xsl:value-of select="$unit"/> (<res:idFluidDram_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[min_br]')"><xsl:value-of select="$unit"/> (<res:idMinim_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[gr]')"><xsl:value-of select="$unit"/> (<res:idGrain/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lb_av]')"><xsl:value-of select="$unit"/> (<res:idPound/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[oz_av]')"><xsl:value-of select="$unit"/> (<res:idOunce/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[dr_av]')"><xsl:value-of select="$unit"/> (<res:idDram/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[scwt_av]')"><xsl:value-of select="$unit"/> (<res:idShortUSHundredweight/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lcwt_av]')"><xsl:value-of select="$unit"/> (<res:idLongBritishHundredweight/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ston_av]')"><xsl:value-of select="$unit"/> (<res:idShortUSTon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lton_av]')"><xsl:value-of select="$unit"/> (<res:idLongBritishTon/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[stone_av]') "><xsl:value-of select="$unit"/> (<res:idBritishStone/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pwt_tr]')"><xsl:value-of select="$unit"/> (<res:idPennyweight/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[oz_tr]')"><xsl:value-of select="$unit"/> (<res:idOunce_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lb_tr]')"><xsl:value-of select="$unit"/> (<res:idPound_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[sc_ap]')"><xsl:value-of select="$unit"/> (<res:idScruple/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[dr_ap]')"><xsl:value-of select="$unit"/> (<res:idDramDrachm/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[oz_ap]')"><xsl:value-of select="$unit"/> (<res:idOunce_auxUCUM_0/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lb_ap]')"><xsl:value-of select="$unit"/> (<res:idPound_auxUCUM_0/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lne]')"><xsl:value-of select="$unit"/> (<res:idLine/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pnt]')"><xsl:value-of select="$unit"/> (<res:idPoint_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pca]')"><xsl:value-of select="$unit"/> (<res:idPica/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pnt_pr]')"><xsl:value-of select="$unit"/> (<res:idPrinterPoint/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pca_pr]')"><xsl:value-of select="$unit"/> (<res:idPrinterPica/>))</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pied]')"><xsl:value-of select="$unit"/> (<res:idPiedFrenchFoot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pouce]')"><xsl:value-of select="$unit"/> (<res:idPouceFrenchInch/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ligne]')"><xsl:value-of select="$unit"/> (<res:idLigneFrenchLine/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[didot]')"><xsl:value-of select="$unit"/> (<res:idDidotPoint/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cicero]')"><xsl:value-of select="$unit"/> (<res:idCiceroDidotPica/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[degf]')"><xsl:value-of select="$unit"/> (<res:idDegreeFahrenheit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cal_[15]')"><xsl:value-of select="$unit"/> (<res:idCalorieAt15C/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cal_[20]')"><xsl:value-of select="$unit"/> (<res:idCalorieAt20C/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cal_m')"><xsl:value-of select="$unit"/> (<res:idMeanCalorie/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cal_it')"><xsl:value-of select="$unit"/> (<res:idIntlTableCalorie/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cal_th')"><xsl:value-of select="$unit"/> (<res:idThermochemCalorie/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'cal')"><xsl:value-of select="$unit"/> (<res:idCalorie/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cal]')"><xsl:value-of select="$unit"/> (<res:idNutritionLabelCalories/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu_39]')"><xsl:value-of select="$unit"/> (<res:idBTUAt39F/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu_59]')"><xsl:value-of select="$unit"/> (<res:idBTUAt59F/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu_60]')"><xsl:value-of select="$unit"/> (<res:idBTUAt60F/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu_m]')"><xsl:value-of select="$unit"/> (<res:idMeanBTU/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu_IT]')"><xsl:value-of select="$unit"/> (<res:idIntlTableBTU/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu_th]')"><xsl:value-of select="$unit"/> (<res:idThermochemBTU/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[btu]')"><xsl:value-of select="$unit"/> (<res:idBTU/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[hp]')"><xsl:value-of select="$unit"/> (<res:idHorsepower/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'm[h2o]')"><xsl:value-of select="$unit"/> (<res:idMeterOfWaterColumn/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'm[hg]')"><xsl:value-of select="$unit"/> (<res:idMeterOfMercuryColumn/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[in_i&apos;h2o]")'><xsl:value-of select="$unit"/> (<res:idInchOfWaterColumn/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[in_i&apos;hg]")'><xsl:value-of select="$unit"/> (<res:idInchOfMercuryColumn/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pru]')"><xsl:value-of select="$unit"/> (<res:idPeripheralVascularResistanceUnit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[diop]')"><xsl:value-of select="$unit"/> (<res:idDiopter/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[p&apos;diop]")'><xsl:value-of select="$unit"/> (<res:idPrismDiopter/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '%[slope]')"><xsl:value-of select="$unit"/> (<res:idPercentOfSlope/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[mesh_i]')"><xsl:value-of select="$unit"/> (<res:idMesh/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ch]')"><xsl:value-of select="$unit"/> (<res:idCharriereFrench/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[drp]')"><xsl:value-of select="$unit"/> (<res:idDrop/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[hnsf&apos;u]")'><xsl:value-of select="$unit"/> (<res:idHounsfieldUnit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[met]')"><xsl:value-of select="$unit"/> (<res:idMetabolicEquivalent/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[hp_x]')"><xsl:value-of select="$unit"/> (<res:idHomeopathicPotencyOfDecimalSeries/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[hp_c]')"><xsl:value-of select="$unit"/> (<res:idHomeopathicPotencyOfCentesimalSeries/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'eq')"><xsl:value-of select="$unit"/> (<res:idEquivalents/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'osm')"><xsl:value-of select="$unit"/> (<res:idOsmole/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ph]')"><xsl:value-of select="$unit"/> (<res:idPh/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'g%')"><xsl:value-of select="$unit"/> (<res:idGramPercent/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[s]')"><xsl:value-of select="$unit"/> (<res:idSvedbergUnit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[hpf]')"><xsl:value-of select="$unit"/> (<res:idHighPowerField/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[lpf]')"><xsl:value-of select="$unit"/> (<res:idLowPowerField/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'kat')"><xsl:value-of select="$unit"/> (<res:idKatal/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'u')"><xsl:value-of select="$unit"/> (<res:idUnit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[iu]')"><xsl:value-of select="$unit"/> (<res:idIntlUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[arb&apos;u]")'><xsl:value-of select="$unit"/> (<res:idArbitaryUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[usp&apos;u]")'><xsl:value-of select="$unit"/> (<res:idUnitedStatesPharmacopeiaUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[gpl&apos;u]")'><xsl:value-of select="$unit"/> (<res:idGPLUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[mpl&apos;u]")'><xsl:value-of select="$unit"/> (<res:idMPLUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[apl&apos;u]")'><xsl:value-of select="$unit"/> (<res:idAPLUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[beth&apos;u]")'><xsl:value-of select="$unit"/> (<res:idBethesdaUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[todd&apos;u]")'><xsl:value-of select="$unit"/> (<res:idToddUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[dye&apos;u]")'><xsl:value-of select="$unit"/> (<res:idDyeUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[smgy&apos;u]")'><xsl:value-of select="$unit"/> (<res:idSomogyiUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[bdsk&apos;u]")'><xsl:value-of select="$unit"/> (<res:idBodanskyUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[ka&apos;u]")'><xsl:value-of select="$unit"/> (<res:idKingArmstrongUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[knk&apos;u]")'><xsl:value-of select="$unit"/> (<res:idKunkelUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[mclg&apos;u]")'><xsl:value-of select="$unit"/> (<res:idMacLaganUnit/>)</xsl:when>
			<xsl:when test='(esri:strtolower($unit) = "[tb&apos;u]")'><xsl:value-of select="$unit"/> (<res:idTuberculinUnit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ccid_50]')"><xsl:value-of select="$unit"/> (<res:id50PctCellCultureInfectiousDose/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[tcid_50]')"><xsl:value-of select="$unit"/> (<res:id50PctTissueCultureInfectiousDose/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[pfu]')"><xsl:value-of select="$unit"/> (<res:idPlaqueFormingUnits/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[ffu]')"><xsl:value-of select="$unit"/> (<res:idImmunofocusFormingUnits/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[cfu]')"><xsl:value-of select="$unit"/> (<res:idColonyFormingUnits/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'np') or (esri:strtolower($unit) = 'nep')"><xsl:value-of select="$unit"/> (<res:idNeper/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b')"><xsl:value-of select="$unit"/> (<res:idBel/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b[spl]')"><xsl:value-of select="$unit"/> (<res:idBelSoundPressure/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b[v]')"><xsl:value-of select="$unit"/> (<res:idBelVolt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b[mv]')"><xsl:value-of select="$unit"/> (<res:idBelMillivolt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b[uv]')"><xsl:value-of select="$unit"/> (<res:idBelMicrovolt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b[w]')"><xsl:value-of select="$unit"/> (<res:idBelWatt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b[kw]')"><xsl:value-of select="$unit"/> (<res:idBelKilowatt/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'st') or (esri:strtolower($unit) = 'str')"><xsl:value-of select="$unit"/> (<res:idStere/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ao')"><xsl:value-of select="$unit"/> (<res:idAngstrom/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'b') or (esri:strtolower($unit) = 'brn')"><xsl:value-of select="$unit"/> (<res:idBarn/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'att')"><xsl:value-of select="$unit"/> (<res:idTechAtmo/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mho')"><xsl:value-of select="$unit"/> (<res:idMho/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[psi]')"><xsl:value-of select="$unit"/> (<res:idPoundPerSqareInch/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'circ')"><xsl:value-of select="$unit"/> (<res:idCircle/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'sph')"><xsl:value-of select="$unit"/> (<res:idSpere/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[car_m]')"><xsl:value-of select="$unit"/> (<res:idMetricCarat/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[car_au]')"><xsl:value-of select="$unit"/> (<res:idCaratOfGoldAlloys/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = '[smoot]')"><xsl:value-of select="$unit"/> (<res:idSmoot/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'bit_s')"><xsl:value-of select="$unit"/> (<res:idBit/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'bit')"><xsl:value-of select="$unit"/> (<res:idBit_auxUCUM/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'by')"><xsl:value-of select="$unit"/> (<res:idByte/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'bd')"><xsl:value-of select="$unit"/> (<res:idBaud/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ki') or (esri:strtolower($unit) = 'kib')"><xsl:value-of select="$unit"/> (<res:idKibi/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'mi') or (esri:strtolower($unit) = 'mib')"><xsl:value-of select="$unit"/> (<res:idMebi/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'gi') or (esri:strtolower($unit) = 'gib')"><xsl:value-of select="$unit"/> (<res:idGibi/>)</xsl:when>
			<xsl:when test="(esri:strtolower($unit) = 'ti') or (esri:strtolower($unit) = 'tib')"><xsl:value-of select="$unit"/> (<res:idTebi/>)</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>