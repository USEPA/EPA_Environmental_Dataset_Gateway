<% // dataBody.jsp -  (JSF body) %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>


<h:outputText escape="false" styleClass="prompt" value="#{gptMsg['catalog.data.home.prompt']}"/>

<f:verbatim>
    <br/><br/>
    <table width="100%">
        <tbody>
            <tr>
                <td width="8%">
                    <a href="/data" style="border-bottom:none;background-color: transparent;">
                        <img src="../images/data_download.png" alt="Data" title="Data"/>
                    </a>
                </td>
                <td valign="top">
                    <div class="prompt">
                         <a href="/data"><b>EDG Data Download Locations</b></a><br/>
                            Download data posted by an EPA Regional Office, Program Office, or Laboratory. Browse folders for each group and download data files.
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <a href="https://edg.epa.gov/clipship/" style="border-bottom:none;background-color: transparent;">
                        <img src="../images/clip.png" alt="Clip" title="Clip"/>
                    </a>
                </td>
                <td valign="top">
                    <div class="prompt">
                        <a href="https://edg.epa.gov/clipship/"><b>EPA's Clip N Ship Site</b></a><br/>
                       Use an interactive web map to select geospatial data for an area of interest and download the data clipped to your selected area.
                    </div>
                </td>
            </tr>

        </tbody>
    </table>
</f:verbatim>

