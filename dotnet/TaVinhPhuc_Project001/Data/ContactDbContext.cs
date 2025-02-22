using Microsoft.EntityFrameworkCore;
using TaVinhPhuc_Project001.Models;

// ContactDbContext là trung gian giữa ứng dụng và database
// DbSet<Contact> đại diện cho bảng Contacts
// Khi EF Core chạy migration, nó sẽ tạo bảng Contacts dựa trên model Contact

namespace TaVinhPhuc_Project001.Data
{
    public class ContactDbContext : DbContext
    {
        public ContactDbContext(DbContextOptions<ContactDbContext> options) : base(options) { }
        public DbSet<ContactModel> Contacts { get; set; }
    }
}
