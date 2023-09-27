<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ConsultingFeesCal.aspx.cs" Inherits="CIS325CFC.ConsultingFeesCalculator.ConsultingFeesCal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="FormPanel" runat="server" CssClass="neumorphic" Style="font-size: large">

       
   
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


        <!-- Styling -->
        <style>
            /* Morphic Styling Imports*/
            @import url("https://fonts.googleapis.com/css?family=Montserrat&display=swap");

            /* Morphic Styling Class*/
            .neumorphic {
                border-radius: 15px;
                background: #e0e0e0;
                box-shadow: 10px 10px 20px #d1d1d1, -10px -10px 20px #ffffff;
            }

            .neumorphic-input {
                border: none;
                border-radius: 15px;
                padding: 10px;
                background: #e0e0e0;
                box-shadow: inset 5px 5px 10px #d1d1d1, inset -5px -5px 10px #ffffff;
            }

            .neumorphic-button {
                border: none;
                border-radius: 15px;
                background: #e0e0e0;
                box-shadow: inset 5px 5px 10px #d1d1d1, inset -5px -5px -10px #ffffff;
                cursor: pointer;
            }

            .neumorphic-button::before {
                 content: "";
                 border: none;
                 border-radius: 15px;
                 padding: 10px 20px;
                 background: #e0e0e0;
                 box-shadow: 5px 5px 10px #d1d1d1, -5px -5px 10px #ffffff;
                 cursor: pointer;
                 transition: all 0.1s ease-in-out;
            }



            .radiogroup {
                padding: 48px 64px;
                border-radius: 16px;
                background: #ecf0f3;
                box-shadow: 4px 4px 4px 0px #d1d9e6 inset, -4px -4px 4px 0px #ffffff inset;
            }


            .radiogroup input[type="radio"] {
                opacity: 1; 
                pointer-events: auto; 
            }


            .radiogroup label {
                display: inline-flex;
                align-items: center;
                cursor: pointer;
                color: #394a56;
            }

            /* You may have to adjust or remove this based on how ASP.NET renders the HTML */
            .radiogroup input[type="radio"]:checked + label {
                /* styles for checked state */
                color: #000;
            }

            .radiogroup input[type="radio"]:focus + label {
                /* styles for focus state */
                color: #000;
            }


            /* Individual styling */
            .text-center {
                font-size: 40px;
            }

            th, .td {
                padding: 10px;
            }

            .centerTextGreen {
                text-align: center;
                color: green;
            }


            


        </style>






        <table class="nav-justified">
            <tr>
                <td class="text-center" id="heading" colspan="3"><strong>Consulting Fees Calculator</strong></td>
            </tr>
            <tr>
                <td style="width: 386px" class="modal-sm">&nbsp;</td>
                <td class="auto-style3">
                    <asp:Label ID="ErrorMsg" runat="server" ForeColor="Red"></asp:Label>
                </td>
            </tr>
            <!-- Consultant Name Section -->
            <tr>
                <td style="padding-left: 125px;" class="auto-style1">Consultant Name<span style="color: #FF0000"><strong>*</strong></span>:</td>
                <td style="padding-bottom: 20px; padding-top: 25px;" width="150px" class="auto-style2">
                    <!-- auto-style3 -->
                    <asp:TextBox ID="ConsultantName" runat="server" Width="250px" CssClass="neumorphic-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFVConsultantName" runat="server" ControlToValidate="ConsultantName" ErrorMessage="Please enter your name." ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
                <td class="auto-style2" style="padding-left: 270px; padding-bottom: 30px;">Job Title<span style="color: #FF0000"><strong>*</strong></span>:</td>
                <td style="padding-top: 20px; padding-bottom: 25px; padding-right: 25px;" class="auto-style2">
                    <asp:DropDownList ID="JobTitle" runat="server" Style="" CssClass="neumorphic-button">
                        <asp:ListItem Value="0">---Please Select---</asp:ListItem>
                        <asp:ListItem Value="Developer">Developer</asp:ListItem>
                        <asp:ListItem Value="Analyst">Analyst</asp:ListItem>
                        <asp:ListItem Value="Architect">Architect</asp:ListItem>
                        <asp:ListItem Value="ProjectLead">Project Lead</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RFVJobTitle" runat="server" ControlToValidate="JobTitle" InitialValue="0"  ErrorMessage="Please select a Job Title." ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <!-- Work Hours -->
            <tr>
                <td style="padding-left: 125px;" class="auto-style1">Work Hours<span style="color: #FF0000"><strong>*</strong></span>:</td>
                <td class="auto-style3">
                    <asp:TextBox ID="HoursWorked" runat="server" Width="74px" CssClass="neumorphic-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFVHoursWorked" runat="server" ControlToValidate="HoursWorked" ErrorMessage="Please enter hours worked." ForeColor="Red"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="RVHoursWorked" runat="server" ControlToValidate="HoursWorked" MinimumValue="0" MaximumValue="100" Type="Integer" ErrorMessage="Please enter a value between 0 and 100." ForeColor="Red"></asp:RangeValidator>
                </td>
            </tr>
            <!-- MCSD Certificate -->
            <tr>
                <td style="width: 386px; padding-left: 125px;" class="modal-sm">MCSD Certificate<span style="color: #FF0000"><strong>*</strong></span>:</td>
                <td style="padding-top: 15px; padding-bottom: 20px;" class="auto-style3">
                    <p style="padding-top: 40px;">Do you have an MCSD Certificate?</p>
                    <asp:RequiredFieldValidator ID="RFVMCSD" runat="server" ControlToValidate="MCSD" ErrorMessage="Please Select Either Option!" ForeColor="Red"></asp:RequiredFieldValidator>
                    <asp:RadioButtonList ID="MCSD" runat="server" CssClass="radiogroup" RepeatDirection="Horizontal">
                        <asp:ListItem Value="Yes">Yes</asp:ListItem>
                        <asp:ListItem Value="No">No</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <!-- Technical Skills -->
            <tr>
                <td style="width: 386px; padding-left: 125px;" class="modal-sm">Technical Skills:</td>
                <td style="padding-top: 20px; padding-bottom: 25px;" class="auto-style3">
                    <asp:CheckBoxList ID="TechnicalSkills" runat="server" Width="300" AutoPostBack="false">
                        <asp:ListItem Value="ASP.NET">ASP.NET</asp:ListItem>
                        <asp:ListItem Value="C#">C#</asp:ListItem>
                        <asp:ListItem Value="XML">XML</asp:ListItem>
                        <asp:ListItem Value="SQL">SQL</asp:ListItem>
                        <asp:ListItem Value="Python">Python</asp:ListItem>
                        <asp:ListItem Value="JavaScript">JavaScript</asp:ListItem>
                        <asp:ListItem Value="PHP">PHP</asp:ListItem>
                        <asp:ListItem Value="MySQL">MySQL</asp:ListItem>
                        <asp:ListItem Value="Other">Other</asp:ListItem>
                    </asp:CheckBoxList>
                </td>
            </tr>
            <!-- Send Email Copy of Invoice -->
            <tr>
                <td style="width: 386px; padding-left: 125px; padding-bottom: 10px;" class="modal-sm">Invoice:</td>
                <td style="padding-top: 15px; padding-bottom: 20px;" class="auto-style3">
                    <p style="padding-top: 40px;">Do you wish to send an email copy of the invoice to your client?</p>
                    <asp:RadioButtonList ID="SendEmail" runat="server" CssClass="radiogroup" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="SendEmail_SelectedIndexChanged">
                        <asp:ListItem Value="Yes">Yes</asp:ListItem>
                        <asp:ListItem Value="No">No</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <!-- Client Name  -->
            <tr id="clientNameRow" runat="server">
                <td style="width: 386px; padding-left: 125px; padding-bottom: 10px;" class="modal-sm">Client Name<span style="color: #FF0000"><strong>*</strong></span>:</td>
                <td style="padding-top: 45px; padding-bottom: 15px;" class="auto-style3" id="clientNameField">
                    <asp:TextBox ID="ClientName" runat="server" Width="250px" CssClass="neumorphic-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFVClientName" runat="server" ControlToValidate="ClientName" ErrorMessage="Please enter client name." ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <!-- Client Email  -->
            <!-- style="display: none; -->
            <tr id="clientEmailRow" runat="server">
                <td style="width: 386px; padding-left: 125px;" class="modal-sm" id="clientEmailLabel">Client Email<span style="color: #FF0000"><strong>*</strong></span>:</td>
                <td style="padding-top: 45px; padding-bottom: 20px;" class="auto-style3" id="clientEmailField">
                    <asp:TextBox ID="ClientEmail" runat="server" Width="250px" CssClass="neumorphic-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RFVClientEmail" runat="server" ControlToValidate="ClientEmail" ErrorMessage="Please enter client email." ForeColor="Red"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="REVClientEmail" runat="server" ControlToValidate="ClientEmail" ErrorMessage="Invalid email format." ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <!-- Calculate Button -->
            <tr>
                <td style="width: 386px" class="modal-sm">&nbsp;</td>
                <td class="auto-style3">
                    <!-- Blank to support the Calculate button-->
                </td>
                <td style="width: 386px">

                </td>
                <td>
                    <asp:Button ID="CalculateButton" runat="server" Width="200" CssClass="neumorphic-button" OnClick="calculateButton_Click" Text="Calculate" Style="border: none; border-radius: 15px; padding: 10px 20px; background: #e0e0e0; box-shadow: 5px 5px 10px #d1d1d1, -5px -5px 10px #ffffff; cursor: pointer; color: red;"/>
                </td>
            </tr>
            <!-- Result Label -->
            <tr>
                <td style="width: 386px" class="modal-sm">&nbsp;</td>
                <td class="auto-style3">
                    <asp:Label ID="ResultLabel" runat="server" Style="font-size: large"></asp:Label>
                </td>
            </tr>
        </table>

        <!-- JS didnt work --> 

    </asp:Panel>

    

    <asp:Label ID="ResultMsg" runat="server" Style="font-size: large"></asp:Label>

    


</asp:Content>
