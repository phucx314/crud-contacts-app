// src/components/ContactDetails.jsx

import React from 'react';
import styled from 'styled-components';
import { useNavigate } from 'react-router-dom';
import { FaChevronLeft, FaEdit } from 'react-icons/fa';
import { useParams } from 'react-router-dom';
import { useContact } from '../hooks/useContact';

const ContactDetailsPage = () => {
  const { id } = useParams();
  const { contact, loading, error } = useContact(id);

  if (loading) return <Loading>Loading...</Loading>;
  if (error) return <Error>{error}</Error>;
  if (!contact) return <NotFound>Contact not found</NotFound>;

  return <ContactDetails contact={contact} />;
};

const ContactDetails = ({ contact }) => {
  const navigate = useNavigate();

  const getValidImageUrl = (url) => {
    return (url && url.length > 0 && url.startsWith('http'))
      ? url
      : 'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png';
  };

  const handleEditClick = () => {
    navigate(`/edit-contact/${contact.id}`);
  };

  return (
    <Container>
      <AppBar>
        <BackButton onClick={() => navigate(-1)}>
          <FaChevronLeft color="white" size={24} />
        </BackButton>
        <Title>Contact details</Title>
        <ActionButton onClick={handleEditClick}>
          <FaEdit color="white" size={24} />
        </ActionButton>
      </AppBar>

      <Content>
        <ImageSection>
          <AvatarContainer onClick={() => alert(contact.avatarUrl)}>
            <Avatar src={getValidImageUrl(contact.avatarUrl)} alt={contact.name} />
          </AvatarContainer>
          <ContactName>{contact.name}</ContactName>
        </ImageSection>

        <Divider />

        <ContactInfo>
          <InfoItem>
            <InfoLabel>Phone number: </InfoLabel>
            <InfoValue>{contact.phoneNumber || 'No phone number'}</InfoValue>
          </InfoItem>

          <Divider thin />

          <InfoItem>
            <InfoLabel>Email: </InfoLabel>
            <InfoValue>{contact.email || 'No email'}</InfoValue>
          </InfoItem>

          <Divider thin />

          <InfoItem>
            <InfoLabel>Home address: </InfoLabel>
            <InfoValue>{contact.homeAddress || 'No address'}</InfoValue>
          </InfoItem>
        </ContactInfo>
      </Content>
    </Container>
  );
};

// Define the missing components
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

const NotFound = styled.div`
  color: white;
  text-align: center;
  margin-top: 2rem;
`;

const Container = styled.div`
  background-color: #141414;
  min-height: 100vh;
`;

const AppBar = styled.div`
  background-color: #1a1a1a;
  padding: 1rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const BackButton = styled.button`
  background: none;
  border: none;
  cursor: pointer;
`;

const Title = styled.h1`
  color: white;
  font-size: 20px;
  font-weight: bold;
  margin: 0;
`;

const ActionButton = styled.button`
  background: none;
  border: none;
  cursor: pointer;
`;

const Content = styled.div`
  padding: 2rem;
`;

const ImageSection = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 2rem;
`;

const AvatarContainer = styled.div`
  width: 165px;
  height: 165px;
  border-radius: 50%;
  overflow: hidden;
  background-color: rgba(255, 255, 255, 0.1);
  padding: 7px;
  cursor: pointer;
`;

const Avatar = styled.img`
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
`;

const ContactName = styled.h2`
  color: white;
  font-size: 28px;
  font-weight: bold;
  margin: 1rem 0;
`;

const Divider = styled.hr`
  border: none;
  height: 1px;
  background-color: ${props => props.thin ? 'rgba(255,255,255,0.1)' : 'rgba(255,255,255,0.2)'};
  margin: 1rem 0;
`;

const ContactInfo = styled.div`
  color: white;
`;

const InfoItem = styled.div`
  margin: 1rem 0;
`;

const InfoLabel = styled.span`
  font-weight: bold;
  font-size: 16px;
`;

const InfoValue = styled.span`
  font-size: 16px;
`;

export default ContactDetailsPage;