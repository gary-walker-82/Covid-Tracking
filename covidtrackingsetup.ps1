$tenant = "blacklightsoftware"
$username = "gary.walker@blacklightsoftware.com"
$siteScriptTitle = "Covid"
$siteScriptDescription = ""
$global:siteScriptId = "" 

function addSiteScript($siteScriptTitle, $siteScriptDescription, $script) {
  $siteScripts = Get-SPOSiteScript 
  $siteScriptObj = $siteScripts | Where-Object {$_.Title -eq $siteScriptTitle} 
  if ($siteScriptObj) {
    $confirmation = Read-Host "There is an existing site script with the same name. Update that?"  
    if ($confirmation -eq 'y') {
      Set-SPOSiteScript -Identity $siteScriptObj.Id -Content $script
      $global:siteScriptId= $siteScriptObj.Id
    }
  }
  else {
    $siteScriptObj = Add-SPOSiteScript -Title $siteScriptTitle -Description $siteScriptDescription -Content $script
    $global:siteScriptId= $siteScriptObj.Id
  }
}
$script = @'
{
  "$schema": "schema.json",
  "actions": [
    {
      "verb": "setRegionalSettings",
      "timeZone": 2,
      "locale": 2057,
      "sortOrder": 25,
      "hourFormat": "24"
    },
    {
      "verb": "setSiteExternalSharingCapability",
      "capability": "Disabled"
    },
    {
      "verb": "createSiteColumn",
      "fieldType": "Text",
      "internalName": "cvdfirstname",
      "displayName": "First Name",
      "isRequired": false,
      "group": "covid",
      "enforceUnique": false
    },
    {
      "verb": "createSiteColumn",
      "fieldType": "Text",
      "internalName": "cvdsurname",
      "displayName": "Surname",
      "isRequired": false,
      "group": "covid",
      "enforceUnique": false
    },
    {
      "verb": "createSiteColumn",
      "fieldType": "DateTime",
      "internalName": "cvdtestdate",
      "displayName": "Test Date",
      "isRequired": false,
      "group": "covid",
      "enforceUnique": false
    },
    {
      "verb": "createSiteColumn",
      "fieldType": "Text",
      "internalName": "cvdtestcode",
      "displayName": "Test Code",
      "isRequired": false,
      "group": "covid",
      "enforceUnique": false
    },
    {
      "verb": "createSiteColumn",
      "fieldType": "DateTime",
      "internalName": "cvddateofconsent",
      "displayName": "Date of Consent",
      "isRequired": false,
      "group": "covid",
      "enforceUnique": false
    },
    {
      "verb": "createSiteColumnXml",
      "schemaXml": "<Field Type=\"Choice\" DisplayName=\"Year Group\" Required=\"FALSE\" Format=\"Dropdown\" StaticName=\"cvdyeargroup\" Name=\"cvdyeargroup\"><Default></Default><CHOICES><CHOICE>7</CHOICE><CHOICE>8</CHOICE><CHOICE>9</CHOICE><CHOICE>10</CHOICE><CHOICE>11</CHOICE><CHOICE>12</CHOICE><CHOICE>13</CHOICE><CHOICE>Staff</CHOICE></CHOICES></Field>",
      "pushChanges": true
    },
    {
      "verb": "createSiteColumnXml",
      "schemaXml": "<Field Type=\"Choice\" DisplayName=\"Form Group\" Required=\"FALSE\" Format=\"Dropdown\" StaticName=\"cvdformgroup\" Name=\"cvdformgroup\"><Default></Default><CHOICES><CHOICE>7AW</CHOICE></CHOICES></Field>",
      "pushChanges": true
    },
    {
      "verb": "createSiteColumnXml",
      "schemaXml": "<Field Type=\"Choice\" DisplayName=\"Test Result\" Required=\"FALSE\" Format=\"Dropdown\" StaticName=\"cvdtestresult\" Name=\"cvdtestresult\"><Default></Default><CHOICES><CHOICE>Positive</CHOICE><CHOICE>Negative</CHOICE><CHOICE>Inconclusive</CHOICE></CHOICES></Field>",
      "pushChanges": true
    },
    {
      "verb": "createSiteColumnXml",
      "schemaXml": "<Field Type=\"Choice\" DisplayName=\"Consent Provided\" Required=\"FALSE\" Format=\"Dropdown\" StaticName=\"cvdconsentprovided\" Name=\"cvdconsentprovided\"><Default>Waiting</Default><CHOICES><CHOICE>Given</CHOICE><CHOICE>Rejected</CHOICE></CHOICES></Field>",
      "pushChanges": true
    },
    {
      "verb": "createContentType",
      "name": "Covid Consent",
      "parentName": "Item",
      "parentId": "0x01",
      "id": "0x0100206FFFDA4D0111EB9008B40CFC2CA371",
      "hidden": false,
      "subactions": [
        {
          "verb": "addSiteColumn",
          "internalName": "cvdfirstname"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdsurname"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdyeargroup"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdformgroup"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvddateofconsent"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdconsentprovided"
        }
      ]
    },
    {
      "verb": "createContentType",
      "name": "Covid Tests",
      "parentName": "Item",
      "parentId": "0x01",
      "id": "0x010035C3C1F04D0111EB83AD680FFC2CA371",
      "hidden": false,
      "subactions": [
        {
          "verb": "addSiteColumn",
          "internalName": "cvdfirstname"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdsurname"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdyeargroup"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdformgroup"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdtestdate"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdtestcode"
        },
        {
          "verb": "addSiteColumn",
          "internalName": "cvdtestresult"
        }
      ]
    },
    {
      "verb": "createSPList",
      "listName": "covid consent",
      "templateType": 100,
      "subactions": [
        {
          "displayName": "title",
          "verb": "deleteSPField"
        },
        {
          "verb": "addContentType",
          "name": "Covid Consent"
        },
        {
          "verb": "removeContentType",
          "name": "item"
        },
        {
          "verb": "addSPView",
          "name": "Consent",
          "query": "",
          "rowLimit": 100,
          "isPaged": false,
          "makeDefault": true,
          "scope": "Default",
          "formatterJSON": "{}",
          "viewFields": [
            "cvdfirstname",
            "cvdsurname",
            "cvdyeargroup",
            "cvdformgroup",
            "cvdconsentprovided",
            "cvddateofconsent"
          ]
        },
        {
          "verb": "addSPView",
          "name": "Students With Consent",
          "query": "<Where><Eq><FieldRef Name=\"cvdconsentprovided\" /><Value Type=\"Text\">Given</Value></Eq></Where>",
          "rowLimit": 100,
          "isPaged": false,
          "makeDefault": false,
          "scope": "Default",
          "formatterJSON": "{}",
          "viewFields": [
            "cvdfirstname",
            "cvdsurname",
            "cvdyeargroup",
            "cvdformgroup",
            "cvdconsentprovided",
            "cvddateofconsent"
          ]
        },
        {
          "verb": "addSPView",
          "name": "Student With No Consent",
          "query": "<Where><Eq><FieldRef Name=\"cvdconsentprovided\" /><Value Type=\"Text\">Rejected</Value></Eq></Where>",
          "rowLimit": 100,
          "isPaged": false,
          "makeDefault": false,
          "scope": "Default",
          "formatterJSON": "{}",
          "viewFields": [
            "cvdfirstname",
            "cvdsurname",
            "cvdyeargroup",
            "cvdformgroup",
            "cvdconsentprovided",
            "cvddateofconsent"
          ]
        },
        {
          "verb": "addSPView",
          "name": "Student Waiting for Consent",
          "query": "<Where><And><Neq><FieldRef Name=\"cvdconsentprovided\" /><Value Type=\"Text\">Rejected</Value></Neq><Neq><FieldRef Name=\"cvdconsentprovided\" /><Value Type=\"Text\">Given</Value></Neq></And></Where>",
          "rowLimit": 100,
          "isPaged": false,
          "makeDefault": false,
          "scope": "Default",
          "formatterJSON": "{}",
          "viewFields": [
            "cvdfirstname",
            "cvdsurname",
            "cvdyeargroup",
            "cvdformgroup",
            "cvdconsentprovided",
            "cvddateofconsent"
          ]
        },
        {
          "verb": "removeSPView",
          "name": "All Items"
        },
        {
          "verb": "setTitle",
          "title": "Covid Consent"
        }
      ]
    },
    {
      "verb": "createSPList",
      "listName": "covid tests",
      "templateType": 100,
      "subactions": [
        {
          "displayName": "title",
          "verb": "deleteSPField"
        },
        {
          "verb": "addContentType",
          "name": "Covid Tests"
        },
        {
          "verb": "removeContentType",
          "name": "item"
        },
        {
          "verb": "addSPView",
          "name": "Results",
          "query": "",
          "rowLimit": 100,
          "isPaged": false,
          "makeDefault": true,
          "scope": "Default",
          "formatterJSON": "{}",
          "viewFields": [
            "cvdfirstname",
            "cvdsurname",
            "cvdyeargroup",
            "cvdformgroup",
            "cvdtestdate",
            "cvdtestcode",
            "cvdtestresult"
          ]
        },
        {
          "verb": "addSPView",
          "name": "Todays Positive Results",
          "query": "<Where><And><Eq><FieldRef Name=\"cvdtestresult\" /><Value Type=\"Text\">Positive</Value></Eq><Eq><FieldRef Name=\"cvdtestdate\" />   <Value IncludeTimeValue='FASLE' Type='DateTime'><Today /></Value></Eq></And></Where>",
          "rowLimit": 100,
          "isPaged": false,
          "makeDefault": true,
          "scope": "Default",
          "formatterJSON": "{}",
          "viewFields": [
            "cvdfirstname",
            "cvdsurname",
            "cvdyeargroup",
            "cvdformgroup",
            "cvdtestdate",
            "cvdtestcode",
            "cvdtestresult"
          ]
        },
        {
          "verb": "removeSPView",
          "name": "All Items"
        },
        {
          "verb": "setTitle",
          "title": "Covid Tests"
        }
      ]
    },
    {
      "verb": "addNavLink",
      "url": "lists\\covid consent",
      "displayName": "Covid Consent",
      "isWebRelative": true,
      "navComponent": "QuickLaunch",
      "isParentUrlWebRelative": false
    },
    {
      "verb": "addNavLink",
      "url": "lists\\covid tests",
      "displayName": "Covid Tests",
      "isWebRelative": true,
      "navComponent": "QuickLaunch"
    }
  ],
  "bindata": {},
  "version": 1
}
'@
Connect-SPOService -Url https://blacklightsoftware-admin.sharepoint.com -Credential $username
addSiteScript $siteScriptTitle $siteScriptDescription $script

function addToSiteDesign($siteDesignTitle) {
  $siteScripts = Get-SPOSiteScript 
  $siteScriptObj = $siteScripts | Where-Object {$_.Title -eq $siteScriptTitle} 
  if($siteScriptObj) {
    $siteDesigns = Get-SPOSiteDesign
    $siteDesignsLength = @($siteDesigns).length
    if($siteDesignsLength -gt 1) {
      $siteDesign = $siteDesigns | Where-Object {$_.Title -eq $siteDesignTitle}
    } elseIf($siteDesignsLength -eq 1){
      if($siteDesigns.Title -eq $siteDesignTitle) {
        $siteDesign = $siteDesigns
      }
    }
    $siteScriptIds = $siteDesign.SiteScriptIds
    if (!($siteDesign.SiteScriptIds -match $siteScriptObj.Id)){
      $siteScriptIds += $siteScriptObj.Id
      Set-SPOSiteDesign -Identity $siteDesign.Id -SiteScripts $siteScriptIds
    }
  } else {
    "No Site Design found with a title " + $siteDesignTitle
  }
}

function addToNewSiteDesign($siteDesignTitle,$siteDesignWebTemplate, $siteScriptId) {
  if($siteScriptId -ne "") {
    Add-SPOSiteDesign -Title $siteDesignTitle -WebTemplate $siteDesignWebTemplate -SiteScripts $siteScriptId
  }
}
addToNewSiteDesign "Covid" 64 $global:siteScriptId