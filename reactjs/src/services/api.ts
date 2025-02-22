import axios from 'axios';
import { Contact } from '../types/Contact';

const BASE_URL = 'http://localhost:8080/api/Contacts';

export const contactService = {
  async getAllContacts(page: number = 1, pageSize: number = 25) {
    try {
      const response = await axios.get(`${BASE_URL}/get-all-contacts?page=${page}&pageSize=${pageSize}`);
      console.log('API Response:', response.data); // Add debugging log
      return response.data.data;
    } catch (error) {
      console.error('API Error:', error.response ? error.response.data : error.message); // Add detailed debugging log
      throw new Error('Failed to get contacts');
    }
  },

  async getContactById(id: number) {
    try {
      const response = await axios.get(`${BASE_URL}/get-a-contact/${id}`);
      return response.data;
    } catch (error) {
      throw new Error('Failed to get contact details');
    }
  },

  async addContact(contact: Contact) {
    try {
      const response = await axios.post(`${BASE_URL}/add-new-contact`, contact);
      return response.data;
    } catch (error) {
      throw new Error('Failed to create new contact');
    }
  },

  async updateContact(id, contact) {
    try {
      console.log('Request Payload:', contact); // Add logging to see the request payload
      const response = await axios.put(`${BASE_URL}/update-contact/${id}`, contact);
      return response.data;
    } catch (error) {
      console.error('API Error:', error.response ? error.response.data : error.message); // Add detailed debugging log
      throw new Error('Failed to update contact');
    }
  },

  async deleteContact(id: number) {
    try {
      await axios.delete(`${BASE_URL}/delete-contact/${id}`);
    } catch (error) {
      throw new Error('Failed to delete contact');
    }
  }
};