import request from './request';

const XCSRFToken = document.querySelector('meta[name="csrf-token"]').content;
console.log(XCSRFToken)

function fetchGET(url) {
  const headers = new Headers({
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-CSRF-Token': XCSRFToken,
  });
  const options = {
    method: 'GET',
    headers,
  };
  return request(url, options);
}

function fetchPOST(url, body) {
  const headers = new Headers({
    'no-cors': true,
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json',
  });

  const options = {
    method: 'POST',
    headers,
    body: JSON.stringify(body),
  };

  return request(url, options);
}


export {
  fetchGET,
  fetchPOST,
};
