using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using iTextSharp.text;
using iTextSharp.text.pdf;
using ListItem = System.Web.UI.WebControls.ListItem;

namespace CIS325CFC.ConsultingFeesCalculator
{
    public partial class ConsultingFeesCal : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Hide the client name and email rows by default
                clientNameRow.Visible = false;
                clientEmailRow.Visible = false;
            }
        }

        protected void SendEmail_SelectedIndexChanged(object sender, EventArgs e)
        {   
            // Simple if and else statemnt
            if (SendEmail.SelectedValue == "Yes")
            {
                clientNameRow.Visible = true;
                clientNameField.Visible = true;
                clientEmailRow.Visible = true;
                clientEmailField.Visible = true;
            }
            else
            {
                clientNameRow.Visible = false;
                clientNameField.Visible = false;
                clientEmailRow.Visible = false;
                clientEmailField.Visible = false;
            }
        }



        protected void calculateButton_Click(object sender, EventArgs e)
        {   // Clarification: https://stackoverflow.com/questions/1039465/should-i-always-call-page-isvalid
            try
            {
                // Make sure the page is valid before proceeding
                if (Page.IsValid)
                {
                    // Retrieve input values from the web form
                    string consultantName = ConsultantName.Text;
                    string jobTitle = JobTitle.SelectedValue;

                    // Safely convert the string to an integer, with error handling
                    if (!int.TryParse(HoursWorked.Text, out int hoursWorked))
                    {
                        // error: could set a label, throw an exception, anything
                        return;
                    }

                    //  Clarification: https://www.tutorialsteacher.com/articles/equality-operator-vs-equals-method-in-csharp
                    //  Clarification: https://www.c-sharpcorner.com/UploadFile/3d39b4/difference-between-operator-and-equals-method-in-C-Sharp/
                    //  string[] not string
                    bool mcsdCertification = MCSD.SelectedValue == "Yes";
                    string[] technicalSkillsApplied = GetSelectedTechnicalSkills();
                    bool sendEmail = SendEmail.SelectedValue == "Yes";
                    string clientName = ClientName.Text;
                    string clientEmail = ClientEmail.Text;

                    // Calculate hourly rate and total fees
                    decimal hourlyRate = CalculateHourlyRate(jobTitle, mcsdCertification);
                    decimal totalFees = CalculateTotalFees(hourlyRate, hoursWorked);

                    // Check if there's overtime and calculate accordingly
                    // bool consistency
                    // decimal, not float
                    bool hasOvertime = hoursWorked > 40;
                    decimal overtimeCharge = 0;
                    int overtimeHours = 0;

                    // Calculate Overtime (think Python)
                    if (hasOvertime)
                    {
                        overtimeHours = hoursWorked - 40;
                        decimal overtimeRate = hourlyRate * 1.5m;
                        overtimeCharge = overtimeHours * overtimeRate;
                    }

                    // Generate invoice message
                    string invoiceMessage = GenerateInvoiceMessage(consultantName, jobTitle, mcsdCertification, technicalSkillsApplied, hoursWorked, totalFees);

                    // Display invoice message
                    ResultLabel.Text = invoiceMessage;

                    // Mixed up with ResultMsg
                    // CssClass applied for the styles
                    // ResultLabel.CssClass = "centerTextGreen";

                    // Send an email if the user chose to do so (or not)
                    if (sendEmail)
                    {
                        byte[] pdfBytes = GenerateInvoicePDF(invoiceMessage);
                        SendInvoiceEmailWithPdf(clientName, clientEmail, invoiceMessage, pdfBytes, hasOvertime, overtimeCharge, overtimeHours);
                    }
                    else
                    {
                        SendInvoiceEmailWithoutPdf(clientName, clientEmail, invoiceMessage, hasOvertime, overtimeCharge, overtimeHours);
                    }

                    // Hides form
                    FormPanel.Visible = false;

                    // Displaying invoice message as displayMessage
                    string displayMessage = GenerateInvoiceMessage(consultantName, jobTitle, mcsdCertification, technicalSkillsApplied, hoursWorked, totalFees);

                    // Appending displayMessage with ResultMsg
                    ResultMsg.Text = displayMessage + "\n\nThe email has been sent! :)";
                    ResultMsg.CssClass = "centerTextGreen"; // Centered and green text
                }
            }
            catch (Exception ex)
            {
                // Handle the exception, maybe display a message or maybe not to the user, depending on my faults
                ResultLabel.Text = "An error occurred: " + ex.Message;
            }
        }



        


        private decimal CalculateHourlyRate(string jobTitle, bool mcsdCertification)
        {
            // Initialize the base hourly rate
            decimal baseHourlyRate = 0;

            // Determine the base hourly rate based on the selected job title
            switch (jobTitle)
            {
                case "Developer":
                    baseHourlyRate = 100;
                    break;
                case "Analyst":
                    baseHourlyRate = 120;
                    break;
                case "Architect":
                    baseHourlyRate = 150;
                    break;
                case "ProjectLead": // Double Check that you didn't add a / , this isn't Python
                    baseHourlyRate = 200;
                    break;
            }

            // If the consultant has MCSD certification, appy a 20% rate increase
            if (mcsdCertification)
            {
                baseHourlyRate *= 1.2m;
            }

            return baseHourlyRate;
        }

        private decimal CalculateTotalFees(decimal hourlyRate, int hoursWorked)
        {
            // Initialize the total fees
            decimal totalFees = hourlyRate * hoursWorked;

            // iF hours worked exceed 40, calculate overtime fees
            if (hoursWorked > 40)
            {
                int overtimeHours = hoursWorked - 40;
                decimal overtimeRate = hourlyRate * 1.5m;
                decimal overtimeFees = overtimeHours * overtimeRate;
                totalFees += overtimeFees;
            }

            return totalFees;
        }


        // Clarification: https://stackoverflow.com/questions/18068007/getting-the-selected-values-in-a-checkbox-list
        // Error with ListItem
        private string[] GetSelectedTechnicalSkills()
        {
            // Create a list to store selected technical skills
            var selectedSkills = new List<string>();

            // Look through the CheckBoxList to find selected skills
            foreach (ListItem item in TechnicalSkills.Items)
            {
                if (item.Selected)
                {
                    selectedSkills.Add(item.Value);
                }
            }

            return selectedSkills.ToArray();
        }


        // This version is used when not attaching a PDF.
        private void SendInvoiceEmailWithoutPdf(string clientName, string clientEmail, string invoiceMessage, bool hasOvertime, decimal overtimeCharge, int overtimeHours)
        {
            try
            {
                // Email sender and recipient setup
                MailAddress from = new MailAddress("hackeroned3v@gmail.com", "Consulting Firm Inc");
                MailAddress to = new MailAddress(clientEmail, clientName);

                // Automatic Fix
                // Create an email message
                MailMessage emailMessage = new MailMessage(from, to)
                {
                    Subject = "Consulting Fees Invoice",
                    Body = invoiceMessage
                };

                // Similar to Python class functionality
                // SMTP client setup
                SmtpClient client = new SmtpClient("smtp.gmail.com", 587)
                {
                    EnableSsl = true,
                    UseDefaultCredentials = false,
                    Credentials = new System.Net.NetworkCredential("hackeroned3v@gmail.com", "amhtqzzjojnakthh"),
                    DeliveryMethod = SmtpDeliveryMethod.Network
                };

                // Send the email
                client.Send(emailMessage);
            }
            catch (Exception ex) // Catch Errors to debug effectively
            {
                // Handle exceptions (log it, display a message, etc.)
                ResultMsg.Text = "An error occurred while sending the email: " + ex.Message;
            }
        }


        // https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/tokens/interpolated $ Inter.

        private string GenerateInvoiceMessage(string consultantName, string jobTitle, bool mcsdCertification, string[] technicalSkillsApplied, int hoursWorked, decimal totalFees)
        {
            // Create the invoice message
            // Python / C# is different
            // Style Invoice: https://www.hiveage.com/blog/how-to-write-invoice-email/
            // https://stackoverflow.com/questions/43075113/what-does-a-question-mark-mean-in-c-sharp-code#43075114
            //  The Conditional Operator/Ternary Operator (MSDN, Benefits of using the conditional ?: (ternary) operator)
            //
            // return isTrue ? "Valid" : "Lie";

            string message = $"Thank you, {consultantName}, for using the consulting fees calculator!\n\n";
            message += $"Based on your selected profile - {jobTitle}, your MCSD certificate status ({(mcsdCertification ? "certified" : "non-certified")}), and {hoursWorked} work hours, your weekly consulting fees are - {totalFees:C}.\n";
            message += $"The technical skills you have applied this week include: {string.Join(", ", technicalSkillsApplied)}.\n";

            // If overtime hours were worked, include overtime information
            if (hoursWorked > 40)
            {
                int overtimeHours = hoursWorked - 40;
                decimal overtimeRate = CalculateHourlyRate(jobTitle, mcsdCertification) * 1.5m;
                decimal overtimeFees = overtimeHours * overtimeRate;
                message += $"\nYour overtime hours this week are {overtimeHours} hours, and your overtime consulting fees are {overtimeFees:C}.";
            }

            return message;
        }

        // invoice message suggested but unused
        // Challenging Byte Translation
        private void SendInvoiceEmailWithPdf(string clientName, string clientEmail, string invoiceMessage, byte[] pdfBytes, bool hasOvertime, decimal overtimeCharge, int overtimeHours)
        {
            // Set email sender information
            string sendFromEmail = "rodney798@flagler.edu";
            string sendFromName = "Consulting Firm Inc";

            // Email subject
            string messageSubject = "Consulting Fees Invoice";

            // Create sender and recipient addresses
            MailAddress from = new MailAddress(sendFromEmail, sendFromName);
            MailAddress to = new MailAddress(clientEmail, clientName);

            // Create an email message
            MailMessage emailMessage = new MailMessage(from, to);

            // Set email subject and body
            // Reference: https://stackoverflow.com/questions/6193070/subject-line-of-email-message
            // Reference: https://community.spiceworks.com/topic/2138649-dot-net-mailto
            // https://www.e-iceblue.com/Tutorials/Spire.Email/Spire.Email-Program-Guide/Send-Email-with-HTML-Body-in-C-VB.NET.html

            string emailBody = $"Dear {clientName},\n\nThanks so much for using our consulting service. " +
                $"The following is a billing summary for the week ending on {DateTime.Now.ToShortDateString()}.\n\n" +
                $"Consultant Name: {clientName}\n" +
                $"MCSD Certificate: {(MCSD.SelectedValue == "Yes" ? "certified" : "non-certified")}\n" +
                $"Technical Skills Applied: {string.Join(", ", GetSelectedTechnicalSkills())}\n" +
                $"Billing Hours: {HoursWorked.Text}\n" +
                $"Total Consulting Fees: {CalculateTotalFees(CalculateHourlyRate(JobTitle.SelectedValue, MCSD.SelectedValue == "Yes"), Convert.ToInt32(HoursWorked.Text)):C}";

            // Include overtime information if applicable
            if (hasOvertime)
            {
                emailBody += $"\n\nOvertime: {overtimeHours} hours\n";
                emailBody += $"Overtime Charge: {overtimeCharge:C}\n";
            }

            emailMessage.Subject = messageSubject;
            emailMessage.Body = emailBody;

            // Create memory stream for PDF attachment
            MemoryStream pdfStream = new MemoryStream(pdfBytes);
            Attachment pdfAttachment = new Attachment(pdfStream, "Invoice.pdf", MediaTypeNames.Application.Pdf);

            // Add PDF attachment to the email
            emailMessage.Attachments.Add(pdfAttachment);

            // Configure the SMTP client
            SmtpClient client = new SmtpClient
            {
                // Set SMTP server and credentials
                Host = "smtp.gmail.com"
            };

            // Network Credential
            System.Net.NetworkCredential basicauthenticationinfo = new System.Net.NetworkCredential("hackeroned3v@gmail.com", "amhtqzzjojnakthh");
            client.Port = int.Parse("587");

            // Secure SSL 
            client.EnableSsl = true;
            client.UseDefaultCredentials = false;
            client.Credentials = basicauthenticationinfo;
            client.DeliveryMethod = SmtpDeliveryMethod.Network;

            // Send's email
            client.Send(emailMessage);

            // Displays a success message
            ResultMsg.Text = "The email has been sent! :)";
        }

        // A little complicated
        // Reference: https://stackoverflow.com/questions/62783608/itextsharp-using-c-sharp-how-to-place-text-onto-pdf 
        // Best Reference: https://www.codeguru.com/dotnet/generating-a-pdf-document-using-c-net-and-itext-7/
        private byte[] GenerateInvoicePDF(string invoiceMessage)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                Document document = new Document();
                // Create a PdfWriter object to write PDF data to the MemoryStream
                PdfWriter writer = PdfWriter.GetInstance(document, ms);

                document.Open();

                // Add a new paragraph containing the invoice message
                document.Add(new Paragraph(invoiceMessage));
                document.Close();

                // Return the PDF data as a byte array
                return ms.ToArray();
            }
        }

    }
}