import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { contactService } from '../services/api.ts';
import styled from 'styled-components';
import { FaEllipsisV, FaPlus } from 'react-icons/fa';

const ContactList = () => {
  const [contacts, setContacts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [page, setPage] = useState(1);
  const [pageSize] = useState(15); // Set page size to 15
  const [dropdownOpen, setDropdownOpen] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchContacts = async () => {
      try {
        const data = await contactService.getAllContacts(page, pageSize);
        console.log('Fetched contacts:', data); // Add debugging log
        setContacts(data || []); // Ensure contacts is an array
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchContacts();
  }, [page, pageSize]);

  const handleNextPage = () => {
    setPage(prevPage => prevPage + 1);
  };

  const handlePreviousPage = () => {
    setPage(prevPage => (prevPage > 1 ? prevPage - 1 : 1));
  };

  const handleContactClick = (id) => {
    navigate(`/contact/${id}`);
  };

  const handleEditContact = (id) => {
    navigate(`/edit-contact/${id}`);
  };

  const handleDeleteContact = async (id) => {
    try {
      await contactService.deleteContact(id);
      setContacts(contacts.filter(contact => contact.id !== id));
    } catch (err) {
      setError(err.message);
    }
  };

  const handleAddContact = () => {
    navigate('/add-contact');
  };

  const toggleDropdown = (id) => {
    setDropdownOpen(dropdownOpen === id ? null : id);
  };

  if (loading) return <Loading>Loading...</Loading>;
  if (error) return <Error>Error: {error}</Error>;

  return (
    <Container>
      <AppBar>
        <Title>Contacts</Title>
      </AppBar>
      
      <List>
        {contacts.length === 0 ? (
          <p>No contacts found</p>
        ) : (
          contacts.map(contact => (
            <ContactCard key={contact.id}>
              <Avatar src={contact.avatarUrl} alt={contact.name} />
              <ContactInfo onClick={() => handleContactClick(contact.id)}>
                <Name>{contact.name}</Name>
                <Phone>{contact.phoneNumber}</Phone>
                <Email>{contact.email}</Email>
                <Address>{contact.homeAddress}</Address>
              </ContactInfo>
              <Options>
                <OptionsButton onClick={() => toggleDropdown(contact.id)}>
                  <FaEllipsisV />
                </OptionsButton>
                {dropdownOpen === contact.id && (
                  <Dropdown>
                    <DropdownItem onClick={() => handleEditContact(contact.id)}>Edit</DropdownItem>
                    <DropdownItem onClick={() => handleDeleteContact(contact.id)}>Delete</DropdownItem>
                  </Dropdown>
                )}
              </Options>
            </ContactCard>
          ))
        )}
      </List>
      
      <Pagination>
        <Button onClick={handlePreviousPage} disabled={page === 1}>Previous</Button>
        <PageNumber>Page {page}</PageNumber>
        <Button onClick={handleNextPage}>Next</Button>
      </Pagination>

      <FloatingButton onClick={handleAddContact}>
        <FaPlus />
      </FloatingButton>
    </Container>
  );
};

const Container = styled.div`
  background-color: #141414;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  position: relative;
`;

const AppBar = styled.div`
  background: #1a1a1a;
  padding: 1rem;
  color: white;
`;

const Title = styled.h1`
  margin: 0;
  text-align: center;
`;

const List = styled.div`
  flex: 1;
  overflow-y: auto;
  padding: 1rem;
`;

const ContactCard = styled.div`
  display: flex;
  align-items: center;
  padding: 1rem;
  margin-bottom: 1rem;
  background: #1a1a1a;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  cursor: pointer;
  color: white;
  position: relative;
`;

const Avatar = styled.img`
  width: 60px;
  height: 60px;
  border-radius: 30px;
  margin-right: 1rem;
`;

const ContactInfo = styled.div`
  flex: 1;
`;

const Name = styled.h3`
  margin: 0 0 0.5rem;
`;

const Phone = styled.p`
  margin: 0;
  color: #ccc;
`;

const Email = styled.p`
  margin: 0;
  color: #ccc;
`;

const Address = styled.p`
  margin: 0;
  color: #ccc;
`;

const Options = styled.div`
  position: relative;
`;

const OptionsButton = styled.button`
  background: none;
  border: none;
  color: white;
  cursor: pointer;
`;

const Dropdown = styled.div`
  position: absolute;
  right: 0;
  top: 100%;
  background: #1a1a1a;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  z-index: 1;
`;

const DropdownItem = styled.div`
  padding: 0.5rem 1rem;
  cursor: pointer;
  &:hover {
    background: #333;
  }
`;

const Pagination = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 1rem;
`;

const Button = styled.button`
  padding: 0.5rem 1rem;
  margin: 0 0.5rem;
  background: #1a1a1a;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  &:disabled {
    background: #ccc;
    cursor: not-allowed;
  }
`;

const PageNumber = styled.span`
  margin: 0 1rem;
`;

const Loading = styled.div`
  color: white;
  text-align: center;
  margin-top: 2rem;
`;

const Error = styled.div`
  color: red;
  text-align: center;
  margin-top: 2rem;
`;

const FloatingButton = styled.button`
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  background: #2b2b2b;
  color: white;
  border: none;
  border-radius: 50%;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  cursor: pointer;
  font-size: 24px;
`;

export default ContactList;