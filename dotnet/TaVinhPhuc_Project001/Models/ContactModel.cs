namespace TaVinhPhuc_Project001.Models
{
    public class ContactModel
    {
        public int ID { get; set; } // Khóa chính
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string HomeAddress { get; set; } = string.Empty;
        public string AvatarUrl { get; set; } = string.Empty;
    }
}
