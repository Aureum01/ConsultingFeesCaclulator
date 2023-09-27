<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CIS325CFC._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- This is basically the default.aspx -->

    <!-- Styles -->
    <style>
        
        .h1
        {
            font-family: Arial;
        }
        
        .th, td
        {
            padding: 10px;
            vertical-align: top;
        }






        .auto-style1 
        {
            height: 106px;
        }

        .CheckBoxList1
        {
            
        }




    </style>

    <!-- Header -->
    <h1>MAT Department Prospective Students Form 2023</h1>

    <asp:Panel ID="PanelForm" runat="server">
        <table style="border: 1px solid black" width="100%">
            <tr>
                <td width="20%"><strong>Student Name*:</strong></td>
                <td width="70%">
                    <asp:TextBox ID="StudentName" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*Please enter your name!" ControlToValidate="StudentName" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td class="auto-style1"><strong>Gender:</strong></td>
                <td class="auto-style1" Height="20px">
                    <asp:RadioButtonList ID="Gender" runat="server" Width="186px" Height="20px" RepeatDirection="Horizontal">
                        <asp:ListItem Value="M">Male</asp:ListItem>
                        <asp:ListItem Value="F">Female</asp:ListItem>
                    </asp:RadioButtonList>
                </td>
            </tr>
            <tr>
                <td><strong>Age*:</strong></td>
                <td>
                    <asp:TextBox ID="AgeB" runat="server" Width="40px"></asp:TextBox>
                    <!-- Age Validator Problem -->
                    <asp:RangeValidator ID="AgeValidator" runat="server" ErrorMessage="*Please Enter Your Age Between 16 to 100" ControlToValidate="AgeB" ForeColor="Red"></asp:RangeValidator>
                </td>
            </tr>
            <tr>
                <td><strong>Email*:</strong></td>
                <td>
                    <asp:TextBox ID="Email" runat="server" TextMode="Email"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*Please enter your email!" ControlToValidate="Email" ForeColor="Red"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td><strong>Intended Major:</strong></td>
                <td>
                    <asp:DropDownList ID="DropDownList1" runat="server">
                        <asp:ListItem Value="0">---Please Select---</asp:ListItem>
                        <asp:ListItem Value="CIS">Computer Information Systems</asp:ListItem>
                        <asp:ListItem Value="DS">Data Science</asp:ListItem>
                        <asp:ListItem Value="Math">Mathematics</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td><strong>Technical Skills:</strong></td>
                <td>
                    <table style="border: 1px dashed black" width="100%">
                        <tr>
                            <td><i>Programming Skills</i></td>
                            <td><i>Developer Tools</i></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:CheckBoxList ID="ProgrammingSkills" runat="server">
                                    <asp:ListItem>C#</asp:ListItem>
                                    <asp:ListItem>Python</asp:ListItem>
                                    <asp:ListItem>C++</asp:ListItem>
                                    <asp:ListItem>Swift</asp:ListItem>
                                    <asp:ListItem>HTML</asp:ListItem>
                                    <asp:ListItem>CSS</asp:ListItem>
                                    <asp:ListItem>Other</asp:ListItem>
                                </asp:CheckBoxList>
                            </td>
                            <td>
                                <asp:CheckBoxList ID="CheckBoxList1" runat="server">
                                    <asp:ListItem>Visual Basic</asp:ListItem>
                                    <asp:ListItem>Visual Studio</asp:ListItem>
                                    <asp:ListItem>PyCharm</asp:ListItem>
                                    <asp:ListItem>Xcode</asp:ListItem>
                                    <asp:ListItem Value="SMS">SQL Management Studio</asp:ListItem>

                                </asp:CheckBoxList>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td><strong>Comments:</strong></td>
                <td>
                    <asp:TextBox ID="Comments" runat="server" TextMode="MultiLine" height="60px" Width="800px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="Submit" runat="server" Text="Submit" OnClick="Submit_Click1" />
                </td>
                <td></td>
            </tr>
            </table>
    </asp:Panel>

</asp:Content>
