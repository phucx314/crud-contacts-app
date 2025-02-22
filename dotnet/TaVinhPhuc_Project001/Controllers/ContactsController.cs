using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using TaVinhPhuc_Project001.Data;
using TaVinhPhuc_Project001.Models;

namespace TaVinhPhuc_Project001.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly ContactDbContext _context;

        public ContactsController(ContactDbContext context)
        {
            _context = context;
        }

        // GET: api/Contacts/get-all-contacts
        [HttpGet("get-all-contacts")]
        public async Task<ActionResult<IEnumerable<ContactModel>>> GetContacts(int page = 1, int contactsPerPage = 115)
        {
            var totalContacts = await _context.Contacts.CountAsync();
            var contacts = await _context.Contacts
                .OrderByDescending(c => c.ID)
                .Skip((page - 1) * contactsPerPage)
                .Take(contactsPerPage)
                .ToListAsync();

            return Ok(new
            {
                TotalContacts = totalContacts,
                CurrentPage = page,
                ContactsPerPage = contactsPerPage,
                Data = contacts,
            });
        }

        // GET: api/Contacts/get-a-contact/{id}
        [HttpGet("get-a-contact/{id}")]
        public async Task<ActionResult<ContactModel>> GetAContact(int id)
        {
            var contact = await _context.Contacts.FindAsync(id);
            if (contact == null)
            {
                return NotFound();
            }
            return contact;
        }

        // POST: api/Contacts/add-new-contact
        [HttpPost("add-new-contact")]
        public async Task<ActionResult<AddNewContactResponse>> CreateContact(ContactModel contact)
        {
            _context.Contacts.Add(contact);
            await _context.SaveChangesAsync();

            var response = new AddNewContactResponse
            {
                Success = true,
                Contact = contact,
            };

            return CreatedAtAction(nameof(GetAContact), new { id = contact.ID }, response);
        }

        // POST: api/Contacts/add-multiple-contacts
        [HttpPost("add-multiple-contacts")]
        public async Task<ActionResult<IEnumerable<ContactModel>>> CreateMultiContact([FromBody] List<ContactModel> contacts)
        {
            if (contacts == null)
            {
                return BadRequest("Chưa nhập danh sách contacts");
            }

            _context.Contacts.AddRange(contacts);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetContacts), contacts);
        }

        // PUT: api/Contacts/update-contact/{id}
        [HttpPut("update-contact/{id}")]
        public async Task<IActionResult> UpdateAContact(int id, ContactModel contact)
        {
            if (id != contact.ID)
            {
                return BadRequest();
            }

            _context.Entry(contact).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/Contacts/delete-contact/{id}]
        [HttpDelete("delete-contact/{id}")]
        public async Task<IActionResult> DeleteAContact(int id)
        {
            var contact = await _context.Contacts.FindAsync(id);
            if (contact == null)
            {
                return NotFound();
            }

            _context.Contacts.Remove(contact);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/Contacts/delete-all-contacts
        [HttpDelete("delete-all-contacts")]
        public async Task<IActionResult> DeleteAllContacts()
        {
            var contacts = await _context.Contacts.ToListAsync();
            if (contacts == null || !contacts.Any())
            {
                return NotFound();
            }

            _context.Contacts.RemoveRange(contacts);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
