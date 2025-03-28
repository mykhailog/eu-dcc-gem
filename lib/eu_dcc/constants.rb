# frozen_string_literal: true

# This list come from official NHS COVID Pass Verifier
# https://github.com/nhsx/covid-pass-verifier/blob/main/NHSCovidPassVerifier/Configuration/commonConfiguration.json
module EuDcc
  CONSTANTS = {
    "VaccineTypes" => {
      "1119349007" => "SARS-CoV2 mRNA vaccine",
      "1119305005" => "SARS-CoV2 antigen vaccine",
      "J07BX03" => "covid-19 vaccines"
    },
    "VaccineManufacturers" => {
      "ORG-100001699" => "AstraZeneca AB",
      "ORG-100030215" => "Biontech Manufacturing GmbH",
      "ORG-100001417" => "Janssen-Cilag International",
      "ORG-100031184" => "Moderna Biotech Spain S.L.",
      "ORG-100006270" => "Curevac AG",
      "ORG-100013793" => "CanSino Biologics",
      "ORG-100020693" => "China Sinopharm International Corp. - Beijing location",
      "ORG-100010771" => "Sinopharm Weiqida Europe Pharmaceutical s.r.o. - Prague location",
      "ORG-100024420" => "Sinopharm Zhijun (Shenzhen) Pharmaceutical Co. Ltd. - Shenzhen location",
      "ORG-100032020" => "Gamaleya Research Institute",
      "Vector-Institute" => "Vector Institute",
      "Sinovac-Biotech" => "Sinovac Biotech",
      "Bharat-Biotech" => "Bharat Biotech",
      "ORG-100002068" => "Valneva Sweden AB"
    },
    "DiseasesTargeted" => {
      "840539006" => "COVID-19"
    },
    "VaccineNames" => {
      "EU/1/20/1528" => "Comirnaty",
      "EU/1/20/1507" => "COVID-19 Vaccine Moderna",
      "EU/1/21/1529" => "Vaxzevria",
      "EU/1/20/1525" => "COVID-19 Vaccine Janssen",
      "CVnCoV" => "CVnCoV",
      "Sputnik-V" => "Sputnik-V",
      "Convidecia" => "Convidecia",
      "EpiVacCorona" => "EpiVacCorona",
      "BBIBP-CorV" => "BBIBP-CorV",
      "Inactivated-SARS-CoV-2-Vero-Cell" => "Inactivated SARS-CoV-2 (Vero Cell)",
      "CoronaVac" => "CoronaVac",
      "Covaxin" => "Covaxin (also known as BBV152 A, B, C)"
    },
    "ReadableVaccineNames" => {
      "EU/1/20/1528" => "Pfizer/BioNTech COVID-19 vaccine",
      "EU/1/21/1529" => "COVID-19 Vaccine AstraZeneca"
    },
    "TestTypes" => {
      "LP6464-4" => "Nucleic acid amplification with probe detection",
      "LP217198-3" => "Rapid immunoassay"
    },
    "TestResults" => {
      "260415000" => "Not detected",
      "260373001" => "Detected"
    },
    "TestManufacturers" => {
      "1833" => "AAZ-LMB, COVID-VIRO",
      "1232" => "Abbott Rapid Diagnostics, Panbio COVID-19 Ag Rapid Test",
      "1468" => "ACON Laboratories, Inc, Flowflex SARS-CoV-2 Antigen rapid test",
      "1304" => "AMEDA Labordiagnostik GmbH, AMP Rapid Test SARS-CoV-2 Ag",
      "1822" => "Anbio (Xiamen) Biotechnology Co., Ltd, Rapid COVID-19 Antigen Test(Colloidal Gold)",
      "1815" => "Anhui Deep Blue Medical Technology Co., Ltd, COVID-19 (SARS-CoV-2) Antigen Test Kit (Colloidal Gold) - Nasal Swab",
      "1736" => "Anhui Deep Blue Medical Technology Co., Ltd, COVID-19 (SARS-CoV-2) Antigen Test Kit(Colloidal Gold)",
      "768" => "ArcDia International Ltd, mariPOC SARS-CoV-2",
      "1654" => "Asan Pharmaceutical CO., LTD, Asan Easy Test COVID-19 Ag",
      "2010" => "Atlas Link Technology Co., Ltd., NOVA Test® SARS-CoV-2 Antigen Rapid Test Kit (Colloidal Gold Immunochromatography)",
      "1906" => "Azure Biotech Inc, COVID-19 Antigen Rapid Test Device",
      "1870" => "Beijing Hotgen Biotech Co., Ltd, Novel Coronavirus 2019-nCoV Antigen Test (Colloidal Gold)",
      "1331" => "Beijing Lepu Medical Technology Co., Ltd, SARS-CoV-2 Antigen Rapid Test Kit",
      "1484" => "Beijing Wantai Biological Pharmacy Enterprise Co., Ltd, Wantai SARS-CoV-2 Ag Rapid Test (FIA)",
      "1223" => "BIOSYNEX S.A., BIOSYNEX COVID-19 Ag BSS",
      "1236" => "BTNX Inc, Rapid Response COVID-19 Antigen Rapid Test",
      "1173" => "CerTest Biotec, CerTest SARS-CoV-2 Card test",
      "1919" => "Core Technology Co., Ltd, Coretests COVID-19 Ag Test",
      "1225" => "DDS DIAGNOSTIC, Test Rapid Covid-19 Antigen (tampon nazofaringian)",
      "1375" => "DIALAB GmbH, DIAQUICK COVID-19 Ag Cassette",
      "1244" => "GenBody, Inc, Genbody COVID-19 Ag Test",
      "1253" => "GenSure Biotech Inc, GenSure COVID-19 Antigen Rapid Kit (REF => P2004)",
      "1144" => "Green Cross Medical Science Corp., GENEDIA W COVID-19 Ag",
      "1747" => "Guangdong Hecin Scientific, Inc., 2019-nCoV Antigen Test Kit (colloidal gold method)",
      "1360" => "Guangdong Wesail Biotech Co., Ltd, COVID-19 Ag Test Kit",
      "1437" => "Guangzhou Wondfo Biotech Co., Ltd, Wondfo 2019-nCoV Antigen Test (Lateral Flow Method)",
      "1256" => "Hangzhou AllTest Biotech Co., Ltd, COVID-19 and Influenza A+B Antigen Combo Rapid Test",
      "1363" => "Hangzhou Clongene Biotech Co., Ltd, Covid-19 Antigen Rapid Test Kit",
      "1365" => "Hangzhou Clongene Biotech Co., Ltd, COVID-19/Influenza A+B Antigen Combo Rapid Test",
      "1844" => "Hangzhou Immuno Biotech Co.,Ltd, Immunobio SARS-CoV-2 Antigen ANTERIOR NASAL Rapid Test Kit (minimal invasive)",
      "1215" => "Hangzhou Laihe Biotech Co., Ltd, LYHER Novel Coronavirus (COVID-19) Antigen Test Kit(Colloidal Gold)",
      "1392" => "Hangzhou Testsea Biotechnology Co., Ltd, COVID-19 Antigen Test Cassette",
      "1767" => "Healgen Scientific, Coronavirus Ag Rapid Test Cassette",
      "1263" => "Humasis, Humasis COVID-19 Ag Test",
      "1333" => "Joinstar Biomedical Technology Co., Ltd, COVID-19 Rapid Antigen Test (Colloidal Gold)",
      "1764" => "JOYSBIO (Tianjin) Biotechnology Co., Ltd, SARS-CoV-2 Antigen Rapid Test Kit (Colloidal Gold)",
      "1266" => "Labnovation Technologies Inc, SARS-CoV-2 Antigen Rapid Test Kit",
      "1267" => "LumiQuick Diagnostics Inc, QuickProfile COVID-19 Antigen Test",
      "1268" => "LumiraDX, LumiraDx SARS-CoV-2 Ag Test",
      "1180" => "MEDsan GmbH, MEDsan SARS-CoV-2 Antigen Rapid Test",
      "1190" => "möLLab, COVID-19 Rapid Antigen Test",
      "1481" => "MP Biomedicals, Rapid SARS-CoV-2 Antigen Test Card",
      "1162" => "Nal von minden GmbH, NADAL COVID-19 Ag Test",
      "1420" => "NanoEntek, FREND COVID-19 Ag",
      "1199" => "Oncosem Onkolojik Sistemler San. ve Tic. A.S., CAT",
      "308" => "PCL Inc, PCL COVID19 Ag Rapid FIA",
      "1271" => "Precision Biosensor, Inc, Exdia COVID-19 Ag",
      "1341" => "Qingdao Hightop Biotech Co., Ltd, SARS-CoV-2 Antigen Rapid Test (Immunochromatography)",
      "1097" => "Quidel Corporation, Sofia SARS Antigen FIA",
      "1606" => "RapiGEN Inc, BIOCREDIT COVID-19 Ag - SARS-CoV 2 Antigen test",
      "1604" => "Roche (SD BIOSENSOR), SARS-CoV-2 Antigen Rapid Test",
      "1489" => "Safecare Biotech (Hangzhou) Co. Ltd, COVID-19 Antigen Rapid Test Kit (Swab)",
      "1490" => "Safecare Biotech (Hangzhou) Co. Ltd, Multi-Respiratory Virus Antigen Test Kit(Swab)  (Influenza A+B/ COVID-19)",
      "344" => "SD BIOSENSOR Inc, STANDARD F COVID-19 Ag FIA",
      "345" => "SD BIOSENSOR Inc, STANDARD Q COVID-19 Ag Test",
      "1319" => "SGA Medikal, V-Chek SARS-CoV-2 Ag Rapid Test Kit (Colloidal Gold)",
      "2017" => "Shenzhen Ultra-Diagnostics Biotec.Co.,Ltd, SARS-CoV-2 Antigen Test Kit",
      "1769" => "Shenzhen Watmind Medical Co., Ltd, SARS-CoV-2 Ag Diagnostic Test Kit (Colloidal Gold)",
      "1574" => "Shenzhen Zhenrui Biotechnology Co., Ltd, Zhenrui ®COVID-19 Antigen Test Cassette",
      "1218" => "Siemens Healthineers, CLINITEST Rapid Covid-19 Antigen Test",
      "1114" => "Sugentech, Inc, SGTi-flex COVID-19 Ag",
      "1466" => "TODA PHARMA, TODA CORONADIAG Ag",
      "1934" => "Tody Laboratories Int., Coronavirus (SARS-CoV 2) Antigen - Oral Fluid",
      "1443" => "Vitrosens Biotechnology Co., Ltd, RapidFor SARS-CoV-2 Rapid Ag Test",
      "1246" => "VivaChek Biotech (Hangzhou) Co., Ltd, Vivadiag SARS CoV 2 Ag Rapid Test",
      "1763" => "Xiamen AmonMed Biotechnology Co., Ltd, COVID-19 Antigen Rapid Test Kit (Colloidal Gold)",
      "1278" => "Xiamen Boson Biotech Co. Ltd, Rapid SARS-CoV-2 Antigen Test Card",
      "1456" => "Xiamen Wiz Biotech Co., Ltd, SARS-CoV-2 Antigen Rapid Test",
      "1884" => "Xiamen Wiz Biotech Co., Ltd, SARS-CoV-2 Antigen Rapid Test (Colloidal Gold)",
      "1296" => "Zhejiang Anji Saianfu Biotech Co., Ltd, AndLucky COVID-19 Antigen Rapid Test",
      "1295" => "Zhejiang Anji Saianfu Biotech Co., Ltd, reOpenTest COVID-19 Antigen Rapid Test",
      "1343" => "Zhezhiang Orient Gene Biotech Co., Ltd, Coronavirus Ag Rapid Test Cassette (Swab)"
    },
    "EnglishCertificateIssuers" => [ "NHS Digital" ],
    "InternationalMinimumDoses" => {
      "EU/1/20/1528" => 2,
      "EU/1/20/1507" => 2,
      "EU/1/21/1529" => 2,
      "EU/1/20/1525" => 1
    }
  }
end
